import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flexpace/common/common.dart';
import 'package:flexpace/common/secure_storage.dart';
import 'package:flexpace/common/service/permission_service.dart';
import 'package:flexpace/common/service/userdata_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ProfileController extends GetxController {
  RxBool isEmail = false.obs;

  RxBool isSMS = false.obs;

  RxString dummy = '로그인 후 이용 가능합니다.'.obs;

  @override
  void onInit() {
    isEmail.value =
        UserDataService.to.userData.value.marketing?['email'] ?? false;
    isSMS.value = UserDataService.to.userData.value.marketing?['sns'] ?? false;
    super.onInit();
  }

  updateMarketing() {
    UserDataService.to.userData.value.marketing?['email'] = isEmail.value;
    UserDataService.to.userData.value.marketing?['sns'] = isSMS.value;

    var firebaseDoc = FirebaseFirestore.instance
        .collection('user')
        .doc(UserDataService.to.userData.value.docId);

    firebaseDoc
        .update({"marketing": UserDataService.to.userData.value.marketing});
  }

  Future<void> updateProfile() async {
    try {
      // 1. 권한 체크
      bool hasPermission =
          await PermissionService.requestPermission(Permission.photos);

      if (!hasPermission) {
        throw '갤러리 접근 권한이 없습니다.';
      }

      // 2. 이미지 선택
      final XFile? pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (pickedImage == null) {
        return; // 사용자가 이미지 선택을 취소한 경우
      }
      Common.isLoading.value = true;

      // 3. Firebase Storage에 업로드
      final String storagePath =
          'users/${UserDataService.to.userData.value.docId}/profile';
      final Reference storageRef =
          FirebaseStorage.instance.ref().child(storagePath);

      // 파일 이름에 타임스탬프 추가하여 중복 방지
      final String fileName =
          'profile_${UserDataService.to.userData.value.docId}';
      final Reference fileRef = storageRef.child(fileName);

      // 파일 업로드
      final File imageFile = File(pickedImage.path);
      final UploadTask uploadTask = fileRef.putFile(imageFile);

      // 업로드 완료 대기 및 URL 획득
      final TaskSnapshot snapshot = await uploadTask;
      final String downloadUrl = await snapshot.ref.getDownloadURL();

      // 4. Firestore 문서 업데이트
      final DocumentReference firebaseDoc = FirebaseFirestore.instance
          .collection('user')
          .doc(UserDataService.to.userData.value.docId);

      final Map<String, dynamic> updateData = {
        'profileImage': {
          'id': fileName,
          'url': downloadUrl,
        }
      };

      await firebaseDoc.update(updateData);

      // 5. 로컬 상태 업데이트
      UserDataService.to.userData.update((val) {
        val?.profileImage = updateData['profileImage'];
      });

      // 성공 메시지 (선택사항)
      Get.showSnackbar(Common.getSnackBar('프로필 이미지가 업데이트되었습니다.'));
    } catch (e) {
      // 에러 처리
      print('프로필 업데이트 에러: $e');
      Get.showSnackbar(Common.getSnackBar('프로필 업데이트 중 문제가 발생했습니다. 다시 시도해주세요.'));

    } finally {
      Common.isLoading.value = false;
    }
  }

  Future<void> deleteUser() async {
    try {
      Common.isLoading.value = true;

      // 현재 사용자 정보 저장
      final String userId = UserDataService.to.userData.value.docId.toString();
      final User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser == null) {
        throw '현재 로그인된 사용자 정보를 찾을 수 없습니다.';
      }

      // Firebase Authentication에서 사용자 삭제
      try {
        await currentUser.delete();
      } on FirebaseAuthException catch (e) {
        // 민감한 작업의 경우 재인증이 필요할 수 있음
        if (e.code == 'requires-recent-login') {
          throw '보안을 위해 다시 로그인 후 탈퇴를 진행해주세요.';
        } else {
          throw '계정 삭제 중 오류가 발생했습니다.';
        }
      }

      // Storage 폴더 삭제
      try {
        final Reference storageRef =
            FirebaseStorage.instance.ref().child('users/$userId');
        final ListResult result = await storageRef.listAll();

        // 폴더 내의 모든 파일 삭제
        await Future.forEach(result.items, (Reference item) async {
          await item.delete();
        });

        // 모든 하위 폴더 삭제
        await Future.forEach(result.prefixes, (Reference prefix) async {
          final ListResult subResult = await prefix.listAll();
          await Future.forEach(subResult.items, (Reference item) async {
            await item.delete();
          });
        });
      } catch (e) {
        print('Storage 삭제 중 에러: $e');
        // Storage 오류가 전체 프로세스를 중단시키지 않도록 함
      }

      // Firestore user 문서 삭제
      try {
        await FirebaseFirestore.instance
            .collection('user')
            .doc(userId)
            .delete();
      } catch (e) {
        print('Firestore user 문서 삭제 중 에러: $e');
        throw '사용자 정보 삭제 중 오류가 발생했습니다.';
      }

      // reserve 컬렉션에서 사용자 관련 문서 삭제
      try {
        final QuerySnapshot reserveDocs = await FirebaseFirestore.instance
            .collection('reserve')
            .where('userId', isEqualTo: userId)
            .get();

        if (reserveDocs.docs.isNotEmpty) {
          final batch = FirebaseFirestore.instance.batch();
          reserveDocs.docs.forEach((doc) {
            batch.delete(doc.reference);
          });
          await batch.commit();
        }
      } catch (e) {
        print('reserve 문서 삭제 중 에러: $e');
        // reserve 문서 삭제 실패가 전체 프로세스를 중단시키지 않도록 함
      }


      await SecureStorage.delete(SecureStorageKeys.id);

      // 로컬 상태 초기화 및 로그인 페이지로 이동
      UserDataService.to.userData.value = UserModel();
      Common.isLoading.value = false;
      Get.offAllNamed('/sign_in');
      Get.showSnackbar(Common.getSnackBar('회원탈퇴가 정상적으로 처리되었습니다.'));


    } catch (e) {
      Get.showSnackbar(Common.getSnackBar('회원탈퇴 중 에러 발생: $e'));
      Common.isLoading.value = false;


    }finally{
      Common.isLoading.value = false;
    }
  }
}
