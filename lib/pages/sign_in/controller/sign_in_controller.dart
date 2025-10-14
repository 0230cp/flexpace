import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flexpace/common/common.dart';
import 'package:flexpace/common/secure_storage.dart';
import 'package:flexpace/common/service/userdata_service.dart';
import 'package:flexpace/pages/social_sign_up/controller/social_sign_up_controller.dart';
import 'package:flutter/services.dart';
import 'package:flutter_naver_login/flutter_naver_login.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';
import "package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart"
    as KaKaoUser;
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignInController extends GetxController {
  String socialKey = '';
  String? socialEmail;
  String socialId = '';

  List social = [
    'assets/social/naver.svg',
    'assets/social/kakao.svg',
    'assets/social/apple.svg',
    'assets/social/google.svg'
  ];

  login(int index) async {
    socialKey = '';
    socialEmail = null;
    socialId = '';
    await routingKey(index);

    try {
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: "${socialId}@flex.pace", password: "flexpace1023@");
      User? user = result.user;

      if (user != null) {
        var firebaseDoc =
            FirebaseFirestore.instance.collection('user').doc(socialId);

        String? fcmToken = await getFCMToken();

        var collection = await firebaseDoc.get();
        var data = collection.data();

        if (data != null) {
          UserDataService.to.userData.value = UserModel.fromJson(data);

          // String userFcmToken = data['fcmToken']?['token'] ?? '';
          // if (userFcmToken != fcmToken) {
          //   firebaseDoc.update({
          //     "fcmToken": {
          //       'token': fcmToken,
          //       'deviceType': Platform.isIOS ? 'iOS' : 'android'
          //     },
          //     "lastAccessTime": DateTime.now(),
          //   });
          //   UserDataService.to.userData.value.fcmToken = {
          //     'token': fcmToken,
          //     'deviceType': Platform.isIOS ? 'iOS' : 'android'
          //   };
          // }
        } else {
          print('로그인에 실패하여 회원가입으로 이동합니다.1');
          routing(index);
          return;
        }

        Logger().w(UserDataService.to.userData.value.toJson());

        await SecureStorage.write(SecureStorageKeys.id, socialId);
        Get.offAllNamed('/main');
      } else {
        print('로그인에 실패하여 회원가입으로 이동합니다.2');
        routing(index);
      }
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code}");

      switch (e.code) {
        case 'invalid-credential':
        case 'user-not-found':
        case 'wrong-password':
          print('로그인에 실패하여 회원가입으로 이동합니다.3');
          routing(index);
          break;
        default:
          Get.showSnackbar(Common.getSnackBar('소셜로그인 시도 중 에러가 발생하였습니다.'));
          print(" $e");
      }
    } catch (e) {
      Get.showSnackbar(Common.getSnackBar('소셜로그인 시도 중 에러가 발생하였습니다.'));
      print(" $e");
    }
  }

  Future<String?> getFCMToken() async {
    try {
      String? token = await FirebaseMessaging.instance.getToken();
      return token;
    } catch (e) {
      print("FCM Token Error: $e");
      return null;
    }
  }

  routing(int index) async {
    if (Get.isRegistered<SocialSignUpController>()) {
      await Get.delete<SocialSignUpController>();
    }

    Get.toNamed('/social_sign_up', arguments: {
      'key': socialKey,
      'socialId': socialId,
      'email': socialEmail
    });
  }

  routingKey(int index) async {
    try {
      switch (index) {
        case 0:
          return await naverLogin();

        case 1:
          return await kakaoLogin();

        case 2:
          return await appleLogin();

        case 3:
          return await googleLogin();

        default:
          return;
      }
    } catch (e) {
      print(e);
    }
  }

  Future<bool> kakaologout() async {
    try {
      await KaKaoUser.UserApi.instance.unlink();
      await KaKaoUser.UserApi.instance.logout();
      return true;
    } catch (e) {
      return false;
    }
  }

  kakaoLogin() async {
    await kakaologout();

    KaKaoUser.OAuthToken? token;

    // 설치 여부
    if (await KaKaoUser.isKakaoTalkInstalled()) {
      try {
        token = await KaKaoUser.UserApi.instance.loginWithKakaoTalk();
        print("카카오톡으로 로그인 성공");
      } catch (error) {
        print('카카오톡으로 로그인 실패 $error');
        // 사용자가 카카오톡 설치 후 디바이스 권한 요청 화면에서 로그인을 취소한 경우,
        // 의도적인 로그인 취소로 보고 카카오계정으로 로그인 시도 없이 로그인 취소로 처리 (예: 뒤로 가기)
        if (error is PlatformException && error.code == 'CANCELED') {
          return;
        }

        // 카카오톡에 연결된 카카오계정이 없는 경우, 카카오계정으로 로그인
        try {
          token = await KaKaoUser.UserApi.instance.loginWithKakaoAccount();
          print('카카오계정으로 로그인 성공');
        } catch (error) {
          print('카카오계정으로 로그인 실패 $error');
        }
      }
    } else {
      try {
        token = await KaKaoUser.UserApi.instance.loginWithKakaoAccount();
        print('카카오계정으로 로그인 성공');
      } catch (error) {
        print('카카오계정으로 로그인 실패 $error');
      }
    }

    if (token != null) {
      KaKaoUser.User user = await KaKaoUser.UserApi.instance.me();

      socialKey = '카카오';
      socialId = user.id.toString();
      socialEmail = user.kakaoAccount?.email;
    } else {
      Get.snackbar('알림', '로그인에 실패하셨습니다. 다시 시도해주세요.');
    }
  }

  naverLogin() async {
    await FlutterNaverLogin.logOutAndDeleteToken();

    final NaverLoginResult result = await FlutterNaverLogin.logIn();
    NaverAccessToken res = await FlutterNaverLogin.currentAccessToken;

    socialKey = '네이버';
    socialId = result.account.id.toString();
    socialEmail = result.account.email.toString();

    print(socialId);
    print(socialEmail);
  }

  Future<void> googleLogin() async {
    try {
      await GoogleSignIn().signOut();
      // Google 로그인 초기화 확인
      if (!await GoogleSignIn().isSignedIn()) {
        // 로그인 시도
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        // 사용자가 로그인을 취소한 경우
        if (googleUser == null) {
          print('Google 로그인 취소됨');
          Get.showSnackbar(Common.getSnackBar('로그인이 취소되었습니다.'));
          return;
        }

        // 로그인 성공시 정보 저장
        socialKey = '구글';
        socialId = googleUser.id;
        socialEmail = googleUser.email;

        print('Google 로그인 성공');
        print('ID: $socialId');
        print('Email: $socialEmail');
      } else {
        print('이미 Google 로그인 되어있음');
      }
    } catch (e) {
      print('Google 로그인 에러: $e');
      Get.showSnackbar(Common.getSnackBar('로그인 중 오류가 발생했습니다. 다시 시도해주세요.'));
    }
  }

  Future<void> appleLogin() async {
    try {
      print("애플 로그인 시작");

      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      if (credential.identityToken != null) {
        print("로그인 성공");
        // 성공 시 처리할 로직
        socialKey = '애플';
        socialId = credential.userIdentifier ?? '';
      }
    } catch (e) {
      print("애플 로그인 에러: $e");
    }
  }

// 에러 처리 함수
  void handleError(dynamic error) {
    String errorMessage = '로그인 중 오류가 발생했습니다.';

    if (error is SignInWithAppleAuthorizationException) {
      switch (error.code) {
        case AuthorizationErrorCode.canceled:
          errorMessage = '로그인이 취소되었습니다.';
          break;
        case AuthorizationErrorCode.failed:
          errorMessage = '인증에 실패했습니다.';
          break;
        case AuthorizationErrorCode.invalidResponse:
          errorMessage = '유효하지 않은 응답입니다.';
          break;
        case AuthorizationErrorCode.notHandled:
          errorMessage = '처리되지 않은 오류가 발생했습니다.';
          break;
        case AuthorizationErrorCode.unknown:
          errorMessage = '알 수 없는 오류가 발생했습니다.';
          break;
        case AuthorizationErrorCode.notInteractive:
        // TODO: Handle this case.
      }
    }

    Get.showSnackbar(Common.getSnackBar(errorMessage));
  }

// 성공 시 처리 함수
  void handleSuccessfulLogin(User user) {
    // 사용자 정보 처리
    final displayName = user.displayName;
    final email = user.email;

    print("Logged in user: $displayName, $email"); // 디버깅용

    // 다음 화면으로 이동 또는 필요한 처리
    Get.offAllNamed('/home'); // 예시
  }
}
