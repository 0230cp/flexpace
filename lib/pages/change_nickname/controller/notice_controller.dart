import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexpace/common/service/userdata_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChangeNickNameController extends GetxController {
  TextEditingController nicknameController = TextEditingController();
  RxBool isErrorNickName = false.obs;
  RxString errorTextNickName = ''.obs;

  @override
  void onInit() {
    nicknameController.text = UserDataService.to.userData.value.nickName.toString();
    super.onInit();
  }

  validateNickName() {
    isErrorNickName.value = false;
    RxString errorTextNickName = ''.obs;

    if (nicknameController.text.length < 2 ||
        nicknameController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      isErrorNickName.value = true;
      errorTextNickName.value = '닉네임은 두 글자 이상 입력해 주세요.(특수문자 입력 불가) ';
    }
  }

  updateNickName() async {
    UserDataService.to.userData.value.nickName = nicknameController.text;

    var firebaseDoc = FirebaseFirestore.instance
        .collection('user')
        .doc(UserDataService.to.userData.value.docId);

    firebaseDoc.update({"nickName": UserDataService.to.userData.value.nickName});

    UserDataService.to.userData.refresh();

    Get.back();
  }

  @override
  void onClose() {
    nicknameController.dispose();
    super.onClose();
  }




}
