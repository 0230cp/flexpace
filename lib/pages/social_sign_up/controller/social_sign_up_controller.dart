import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flexpace/common/common.dart';
import 'package:flexpace/common/secure_storage.dart';
import 'package:flexpace/pages/social_sign_up/widget/terms_confirm_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';

class SocialSignUpController extends GetxController {
  String key = '';
  String email = '';
  String socialId = '';
  RxBool isCondSend = false.obs;
  bool canCheckNumber = false;
  RxBool isCheckNumber = false.obs;
  RxBool isNotEmptyCheckNumber = false.obs;

  @override
  void onInit() {
    key = Get.arguments['key'];
    socialId = Get.arguments['socialId'];

    if (Get.arguments['email'] != null) {
      email = Get.arguments['email'];
      emailController.text = email;
    }

    super.onInit();
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController nicknameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController checkNumberController = TextEditingController();

  Map<String, String> logo = {
    '네이버': 'assets/social/naver_logo.svg',
    '카카오': 'assets/social/kakao_logo.svg',
    '애플': 'assets/social/apple_logo.svg',
    '구글': 'assets/social/google_logo.svg'
  };

  RxBool allAgree = false.obs;
  List<RxBool> agreeList = [
    false.obs,
    false.obs,
    false.obs,
    false.obs,
    false.obs
  ];

  List<String> termsConditions = [
    '서비스 이용약관 (필수)',
    '개인정보 수집 및 이용 (필수)',
    '본인은 만 14세 이상입니다. (필수)',
    '이벤트 등 프로모션 알림 SMS 수신 (선택)',
    '이벤트 등 프로모션 알림 메일 수신 (선택)'
  ];

  Future<void> checkAll() async {
    allAgree.toggle();
    for (RxBool agree in agreeList) {
      agree.value = allAgree.value;
    }
    if (allAgree.value) {
      await openDialog(false);
      await openDialog(true);
    }
  }

  void checkOne(int index) {
    agreeList[index].toggle();
    allAgree.value = false;
    if (index == 0 && agreeList[index].value) {
      openDialog(true);
    }
    if (index == 1 && agreeList[index].value) {
      openDialog(false);
    }
  }

  RxInt remainSeconds = 0.obs;
  Timer? _timer;
  RxString timerTextMobileNumber = '5:00'.obs;

  Future<void> sendAuthNumberTap() async {
    try {
      // 휴대폰 번호가 비어있는지 체크
      if (mobileNumber.isEmpty) {
        Get.showSnackbar(Common.getSnackBar('휴대폰 번호를 입력해주세요.'));
        return;
      }

      await duplicationMobileNumber();

      if (isErrorMobileNumber.value) {
        return;
      }

      if (isCheckNumber.value) {
        Get.showSnackbar(Common.getSnackBar('인증이 완료되었습니다.'));
        return;
      }

      ///파이어베이스 문자 전송
      final bool sent = await sendAuthNumber();
      if (sent) {
        isCondSend.value = true;
        startTimer();
      } else {
        Get.showSnackbar(Common.getSnackBar('인증번호 전송에 실패했습니다.'));
      }
    } catch (e, stackTrace) {
      print('Error in sendAuthNumberTap: $e');
      print('Stack trace: $stackTrace');
      Get.showSnackbar(Common.getSnackBar('오류가 발생했습니다. 다시 시도해주세요.'));
    }
  }

  Future<void> startTimer() async {
    // 이미 실행 중인 타이머가 있다면 취소
    _timer?.cancel();

    // 300초(5분) 설정
    remainSeconds.value = 300;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainSeconds.value > 0) {
        remainSeconds.value--;
        timerTextMobileNumber.value = timerText;
        canCheckNumber = true;
      } else {
        timer.cancel();
        timerTextMobileNumber.value = '인증 시간 만료';
        canCheckNumber = false;
      }
    });
  }

  String get timerText {
    int minutes = remainSeconds.value ~/ 60;
    int seconds = remainSeconds.value % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  void emptyCheck() {
    if (checkNumberController.text.isNotEmpty) {
      isNotEmptyCheckNumber.value = true;
    } else {
      isNotEmptyCheckNumber.value = false;
    }
  }

  Future<void> checkNumber() async {
    if (isCheckNumber.value) {
      Get.showSnackbar(Common.getSnackBar('인증이 완료되었습니다.'));
      return;
    }

    if (!isNotEmptyCheckNumber.value) {
      Get.showSnackbar(Common.getSnackBar('인증번호를 입력해주세요.'));
      return;
    }

    if (!canCheckNumber) {
      Get.showSnackbar(Common.getSnackBar('인증 시간이 만료되었습니다. 다시 시도해주세요.'));
      return;
    }

    // if (checkNumberController.text == '12345') {
      //todo 결제 되면 아래 주석 해지
      if (await validAuthNumber(checkNumberController.text)) {

      isCheckNumber.value = true;
      _timer?.cancel();
      Get.showSnackbar(Common.getSnackBar('인증에 성공하였습니다.'));
    } else {
      isCheckNumber.value = false;
      Get.showSnackbar(Common.getSnackBar('인증코드가 맞지 않습니다.'));
    }
  }

  Future<void> registerUser() async {
    await duplicationEmail();

    if (nameController.text.isEmpty ||
        nicknameController.text.isEmpty ||
        emailController.text.isEmpty ||
        phoneNumberController.text.isEmpty ||
        isErrorName.value ||
        isErrorNickName.value ||
        isErrorEmail.value ||
        isErrorMobileNumber.value ||
        !isCheckNumber.value ||
        !agreeList[0].value ||
        !agreeList[1].value ||
        !agreeList[2].value) {
      Get.showSnackbar(Common.getSnackBar('필수 항목이 비어있습니다.'));
      return;
    }

    try {
      Common.isLoading.value = true;
      FirebaseAuth auth = FirebaseAuth.instance;

      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: "$socialId@flex.pace",
        password: "flexpace1023@",
      );

      if (userCredential.user != null) {
        var collection = FirebaseFirestore.instance.collection('user');

        // FCM 토큰 얻기
        String? fcmToken = await getFCMToken();

        Map<String, dynamic> userData = {
          'docId': socialId,
          'name': nameController.text,
          'nickName': nicknameController.text,
          'email': emailController.text,
          'phoneNumber': mobileNumber,
          'platform': key,
          'createdAt': DateTime.now(),
          'profileImage': null,
          'marketing': {
            'email': agreeList[3].value,
            'sns': agreeList[4].value
          },
        };

        // FCM 토큰이 있는 경우에만 추가
        if (fcmToken != null) {
          userData['fcmToken'] = {
            'token': fcmToken,
            'deviceType': Platform.isIOS ? 'iOS' : 'android'
          };
        }

        await collection.doc(socialId).set(userData);

        Get.offAllNamed('/sign_in');
        Get.showSnackbar(Common.getSnackBar('가입이 완료되었습니다. 다시 로그인 해주세요'));
      } else {
        Get.showSnackbar(Common.getSnackBar('에러가 발생하였습니다.'));
      }
    } catch (e) {
      Get.showSnackbar(Common.getSnackBar('회원가입 중 에러가 발생하였습니다.'));
      print('Registration Error: $e');
    } finally {
      Common.isLoading.value = false;
    }
  }

  RxBool isErrorName = false.obs;
  RxBool isErrorNickName = false.obs;
  RxBool isErrorEmail = false.obs;
  RxBool isErrorMobileNumber = false.obs;

  RxString errorTextName = ''.obs;
  RxString errorTextNickName = ''.obs;
  RxString errorTextEmail = ''.obs;
  RxString errorTextMobileNumber = ''.obs;

  validateName() {
    isErrorName.value = false;
    errorTextName.value = '';

    if (nameController.text.isEmpty ||
        nameController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>\d]'))) {
      isErrorName.value = true;
      errorTextName.value = '올바른 이름을 입력해주세요';
    }
  }

  validateNickName() {
    isErrorNickName.value = false;
    errorTextNickName.value = '';

    if (nicknameController.text.length < 2 ||
        nicknameController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      isErrorNickName.value = true;
      errorTextNickName.value = '닉네임은 두 글자 이상 입력해 주세요.(특수문자 입력 불가) ';
    }
  }

  validateEmail() {
    isErrorEmail.value = false;
    errorTextEmail.value = '';

    if (emailController.text.isEmpty || !emailController.text.isEmail) {
      isErrorEmail.value = true;
      errorTextEmail.value = '올바른 이메일을 입력해주세요';
    }
  }
  String mobileNumber = '';

  validateMobileNumber(String value) async {
    value = value.replaceAll("-", "");
    mobileNumber = value;

    phoneNumberController.text = Common.getFormattedMobileNumber(value);


    isErrorMobileNumber.value = false;
    errorTextMobileNumber.value = '';

    try {
      if (mobileNumber.isEmpty ||
          !mobileNumber.isPhoneNumber) {
        isErrorMobileNumber.value = true;
        errorTextMobileNumber.value = '올바른 휴대폰 번호를 입력해주세요';
      }
    } catch (e) {
      print('$e');
    }
  }

  Future<void> duplicationMobileNumber() async {
    try {
      isErrorMobileNumber.value = false;
      errorTextMobileNumber.value = '';

      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('phoneNumber', isEqualTo: mobileNumber)
          .get();

      isErrorMobileNumber.value = querySnapshot.docs.isNotEmpty;
      if (isErrorMobileNumber.value) {
        errorTextMobileNumber.value = '해당 휴대폰 번호는 등록되어 있습니다. 다른 번호를 입력해 주세요.';
      }
    } catch (e, stackTrace) {
      print('Error in duplicationMobileNumber: $e');
      print('Stack trace: $stackTrace');
      throw Exception('휴대폰 번호 중복 확인 중 오류가 발생했습니다: $e');
    }
  }

  duplicationEmail() async {
    isErrorEmail.value = false;
    errorTextEmail.value = '';

    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('user')
          .where('email', isEqualTo: emailController.text)
          .get();

      isErrorEmail.value = querySnapshot.docs.isNotEmpty;
      if (isErrorEmail.value) {
        isErrorEmail.value = true;
        errorTextEmail.value = '이미 등록된 이메일 입니다. 다른 이메일을 사용해 주세요.';
        return;
      }
    } catch (e) {
      print('$e');
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

  @override
  void onClose() {
    nameController.dispose();
    nicknameController.dispose();
    emailController.dispose();
    phoneNumberController.dispose();
    checkNumberController.dispose();
    _timer?.cancel();
    super.onClose();
  }

  String verificationId = "";
  bool codeSent = false;
  bool verificationComplete = false;
  Completer<bool>? _codeSentCompleter;

  Future<bool> sendAuthNumber() async {
    _codeSentCompleter = Completer<bool>();

    try {
      Common.isLoading.value = true;

      await FirebaseAuth.instance.verifyPhoneNumber(
        timeout: const Duration(seconds: 120),
        phoneNumber: "+82$mobileNumber",
        verificationCompleted: (PhoneAuthCredential credential) async {
          print('성공$credential');
        },
        verificationFailed: (FirebaseAuthException error) {
          String errorMessage;
          switch (error.code) {
            case 'invalid-phone-number':
              codeSent = false;
              errorMessage = '유효하지 않은 전화번호입니다. 다시 확인해 주세요.';
              break;
            case 'too-many-requests':
              codeSent = false;
              errorMessage = '요청이 너무 많습니다. 나중에 다시 시도해주세요.';
              break;
            case 'network-request-failed':
              codeSent = false;
              errorMessage = '네트워크 오류가 발생했습니다. 인터넷 연결을 확인해 주세요.';
              break;
            case 'quota-exceeded':
              codeSent = false;
              errorMessage = '오늘의 인증 요청 할당량을 초과했습니다. 내일 다시 시도해주세요.';
              break;
            case 'app-not-authorized':
              codeSent = false;
              errorMessage = '앱이 인증되지 않았습니다. 고객센터로 문의를 부탁드립니다..';
              break;
            case 'captcha-check-failed':
              codeSent = false;
              errorMessage = 'reCAPTCHA 검사를 통과하지 못했습니다. 다시 시도해주세요.';
              break;
            case 'session-expired':
              codeSent = false;
              errorMessage = '인증 세션이 만료되었습니다. 다시 시도해주세요.';
              break;
            case 'invalid-verification-id':
              codeSent = false;
              errorMessage = '잘못된 인증 ID입니다. 다시 시도해주세요.';
              break;
            default:
              codeSent = false;
              errorMessage = '인증 실패: ${error.message}';
              break;
          }

          Get.showSnackbar(Common.getSnackBar(errorMessage));

          codeSent = false;
          _codeSentCompleter?.complete(false);
        },
        codeSent: (String id, int? resendToken) {
          verificationId = id;
          codeSent = true;
          _codeSentCompleter?.complete(true);
        },
        codeAutoRetrievalTimeout: (String id) {
          if (!_codeSentCompleter!.isCompleted) {
            _codeSentCompleter?.complete(false);
          }
        },
      );

      // codeSent 콜백이 호출될 때까지 대기
      return await _codeSentCompleter!.future;
    } catch (e) {
      Get.showSnackbar(Common.getSnackBar('나중에 다시 시도해 보세요.'));
      return false;
    } finally {
      Common.isLoading.value = false;
    }
  }

  Future<bool> validAuthNumber(String authNumber) async {
    if (verificationId.isEmpty) {
      Get.showSnackbar(Common.getSnackBar('인증번호를 먼저 요청해주세요.'));
      return false;
    }

    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      Common.isLoading.value = true;

      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: authNumber,
      );

      final UserCredential userCredential =
          await auth.signInWithCredential(credential);
      verificationComplete = true;

      if (userCredential.user != null) {
        verificationComplete = true;
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'invalid-phone-number':
          Get.showSnackbar(Common.getSnackBar('유효하지 않은 전화번호입니다.'));
          break;
        case 'too-many-requests':
          Get.showSnackbar(Common.getSnackBar('요청이 너무 많습니다. 잠시 후 다시 시도해주세요.'));
          break;
        case 'quota-exceeded':
          Get.showSnackbar(
              Common.getSnackBar('SMS 전송 한도가 초과되었습니다. 나중에 다시 시도해주세요.'));
          break;
        case 'session-expired':
          Get.showSnackbar(
              Common.getSnackBar('인증 세션이 만료되었습니다. 인증 코드를 다시 요청해주세요.'));
          break;
        case 'invalid-verification-code':
          Get.showSnackbar(Common.getSnackBar('잘못된 인증 코드입니다. 다시 확인해주세요.'));
          break;
        case 'missing-verification-code':
          Get.showSnackbar(Common.getSnackBar('인증 코드를 입력해주세요.'));
          break;
        case 'captcha-check-failed':
          Get.showSnackbar(Common.getSnackBar('캡차 검증에 실패했습니다. 다시 시도해주세요.'));
          break;
        case 'network-request-failed':
          Get.showSnackbar(
              Common.getSnackBar('네트워크 오류가 발생했습니다. 인터넷 연결을 확인해주세요.'));
          break;
        default:
          Get.showSnackbar(Common.getSnackBar('알 수 없는 오류가 발생했습니다: ${e.code}'));
          break;
      }
      return false;
    } finally {
      Common.isLoading.value = false;
    }
  }

  openDialog(bool isTerms) async {
    await Get.dialog(TermsConfirmWidget(
        onSubmit: () {
          Get.close(0);
        },
        termsList: isTerms ? termsList : privacyList,
        isTerms: isTerms));
  }

  List termsList = [
    {
      'title': "제 1조 (목적)",
      'contents':
          '본 약관은 진피아(Jinpia) (이하 "회사")가 제공하는 공간대여 서비스 FLEXPACE (이하 "서비스")의 이용조건 및 절차, 권리, 의무 및 책임사항 등을 규정함을 목적으로 합니다.',
    },
    {
      'title': "제 2조 (정의)",
      'contents': '''
1. "앱"이란 FLEXPACE가 제공하는 공간대여 예약 서비스가 가능한 애플리케이션을 의미합니다.
2. "호스트"란 자신의 공간을 FLEXPACE를 통해 대여하고자 하는 개인 또는 법인을 의미합니다.
3. "게스트"란 FLEXPACE를 통해 공간을 예약하고 이용하는 개인 또는 법인을 의미합니다.
4. "공간"이란 호스트가 대여 가능한 장소를 의미합니다.
''',
    },
    {
      'title': "제 3조 (서비스의 제공)",
      'contents': '''
1. 회사는 게스트가 호스트의 공간을 검색, 예약할 수 있는 중개 플랫폼을 제공합니다.
2. 결제는 앱 외부에서 호스트와 게스트 간의 협의 하에 이루어지며, 계좌이체 및 세금계산서 발행 등의 방식이 사용될 수 있습니다.
''',
    },
    {
      'title': "제 4조 (공간 예약)",
      'contents': '''
1. 예약은 게스트가 앱을 통해 호스트에게 요청하고, 호스트가 이를 확인하여 승인하는 방식으로 이루어집니다.
2. 예약이 확정되면 호스트는 게스트와 직접 연락하여 결제 및 예약 확정, 이용 안내 등의 절차를 진행합니다.
''',
    },
    {
      'title': "제 1조 (목적)",
      'contents': '''
1. **예약 취소**
    - 게스트는 예약 확정 후 호스트와 직접 연락하여 취소 및 환불을 요청할 수 있습니다. 회사는 예약 취소에 따른 절차에 개입하지 않습니다.
2. **환불**
    - 환불 조건은 호스트와 게스트 간의 협의에 따라 결정됩니다. 기본적으로 호스트가 환불률을 정할 수 있으며, 계좌이체의 경우 결제 당일 이후에는 취소 수수료가 발생할 수 있습니다.
    - 미성년자의 예약은 법정대리인의 동의가 필요하며, 동의 없이 예약된 경우 전액 취소됩니다.
''',
    },
    {
      'title': "제 6조 (책임 및 면책)",
      'contents': '''
1. 회사는 게스트와 호스트 간의 거래에 대한 중개자 역할을 수행하며, 공간 이용과 관련된 어떠한 책임도 지지 않습니다.
2. 호스트는 예약된 공간의 상태 유지 및 게스트와의 원활한 소통에 대한 모든 책임을 집니다.
3. 게스트는 공간 이용 중 발생한 손해에 대한 책임이 있으며, 공간 이용 전 시설 상태를 반드시 확인해야 합니다.
''',
    },
    {
      'title': "제 7조 (이용 제한)",
      'contents': '''
1. 게스트 및 호스트가 본 약관을 위반하거나 부적절한 행위를 하는 경우, 회사는 사전 통보 없이 서비스 이용을 제한할 수 있습니다.
2. 반복적인 허위 예약, 공간의 고의적 훼손, 기타 법령 위반 등이 발견될 경우 즉시 서비스 이용이 중지될 수 있습니다.
''',
    },
    {
      'title': "제 8조 (분쟁의 처리)",
      'contents': '''
1. 분쟁 발생 시, 회사는 중개자로서의 역할만을 수행하며, 구체적인 분쟁 해결은 게스트와 호스트 간의 협의에 의해 이루어져야 합니다.
2. 양 당사자 간의 협의가 원활하지 않을 경우, 법적 조치가 취해질 수 있으며, 이 과정에서 발생하는 모든 책임은 당사자에게 있습니다.
3. 게스트와 호스트 간 문제가 없도록, 공간 이용전 사진, CCTV 등 영상자료 확보, 시설파손 등에 대한 계약을 따로 작성하시길 권유드립니다.
4. FLEXPACE에 있는 공간 사진은 호스트 및 사진작가가 찍은 사진으로, 실제 공간 이용 시 차이는 있을 수 있습니다.
5.  "게스트" 이용 제한
    
    회사는 게스트가 본 운영정책 및 법령상의 의무를 위반하거나 FLEXPACE 서비스의 정상적인 운영을 방해한 경우 이용 제한, 영구 이용정지(계약해지 및 재가입 제한) 등의 방법으로 서비스 이용을 제한할 수 있습니다.
    
    - A) 다음의 경우, 해당 게스트는 서비스 내에서 특정 공간에 대한 접근 및 이용이 제한될 수 있습니다.
        - a) 공간에서 불법 행위 또는 비정상적인 행위를 한 경우
        - b) 고의 또는 과실로 공간 이용수칙을 위반하여 사업장에 손해를 입힌 경우 (물품 파손 등)
        - c) 욕설, 모욕, 폭언, 성희롱, 성추행, 위협, 폭력 등의 행위를 한 경우
        - d) 이용 의사 없이 허위 예약 또는 반복적으로 예약 후 취소 행위를 한 경우
        - e) Q&A 등 도배성 게시물을 지속적으로 작성한 경우
        - f) 운영정책 및 관련 법령 위반 등 기타 객관적으로 회사가 이용제한 등을 할 필요가 있다고 인정되는 경우
    - B) 다음의 경우, 해당 게스트는 서비스 이용이 제한될 수 있습니다.
        - a) 불편사항을 과장, 허위로 이용후기로 남기거나, 처리를 요청하는 경우
        - b) 호스트가 게스트의 불편사항을 즉시 확인 후 처리하기 위해 최선을 다하고 (다른 공간 사용 및 재이용 시 추가 사용 가능하도록 하는 등) 현장에서 게스트와 협의가 되었으나, 해당 게스트가 지속적으로 해당 호스트에게 불합리한 요구를 지속하는 경우
        - c) 공간을 이용하고, 이용하지 않았다고 허위로 신고하는 경우
        - d) 운영정책 및 관련 법령 위반 등 기타 객관적으로 회사가 이용제한 등을 할 필요가 있다고 인정되는 경우
6. 영상정보처리기기 설치 및 운영
    - A) FLEXPACE에 공간을 유통하는 운영자 (이하 "호스트")의 경우 범죄 예방, 화재 예방, 고객 안전 및 시설 보호를 위하여 CCTV 및 영상 정보 처리 기기를 설치-운영할 수 있습니다.
    - B) 위의 목적으로 영상정보처리기기를 설치 및 운영한 경우 아래의 내용을 반드시 공간 현장에 안내문으로 부착하여 고객이 인지하도록 하여야 합니다.
        - a) 범죄 예방, 시설 보호, 화재 예방 등 안전의 목적으로 실내에 "CCTV가 설치되어 있는 사실 명기"
        - b) CCTV의 촬영 시간 명기
        - c) CCTV의 설치 장소, 설치 대수 표기
        - d) 실내의 경우 CCTV 카메라 위치 및 '촬영중 부착문' 표기 ( * 카메라 위장은 이용자에게 '불법 촬영'으로 판단될 수 있으므로 카메라 옆에 CCTV 촬영중 부착 필수)
        - e) CCTV 관리 책임자 및 연락처 표기
        - f) 영상물 보관기간, 보관장소 및 처리 방법 표기 (* 통상 공공기관 기준으로 30일 자동보관 후 폐기함을 명기하고 있습니다)
    - C) 위 B) 사항의 a) ~ g) 가이드를 준수하지 않은 경우는 개인정보보호법 위반으로 FLEXPACE에서는 아래와 같은 서비스 제재가 이어집니다.
        - a) FLEXPACE에 해당 공간 즉시 미노출 및 해당 업체 재등록 불가
''',
    },
    {
      'title': "제 9조 (약관의 변경)",
      'contents': '''
1. 회사는 서비스 운영상 필요할 경우 약관을 변경할 수 있으며, 변경된 약관은 공지 또는 앱을 통해 고지합니다.
2. 약관 변경 후에도 서비스를 계속 이용하는 경우, 변경된 약관에 동의한 것으로 간주합니다.
''',
    },
    {
      'title': "부칙 (시행일)",
      'contents': '''
본 약관은 2024년 10월 1일부터 적용됩니다
''',
    },
  ];

  List privacyList = [
    {
      'title': "제1조 (개인정보 수집 항목 및 방법)",
      'contents': '''
1. **개인정보 수집 항목**
    1. **게스트회원 가입 시**:
        - 수집 항목: 성명, 이메일 주소, 휴대폰 번호(점유인증 정보 포함).
        - 수집 목적: 회원가입, 서비스 제공, 개인 맞춤형 서비스 제공 및 광고 정보 전달.
        - 보유 기간: 동의 철회 또는 회원 탈퇴 시까지.
    2. **예약  과정**:
        - 수집 항목: 성명, 이메일 주소, 휴대폰 번호
        - 수집 목적: 예약 확인, 고객 지원.
        - 보유 기간: 회원 탈퇴 시 또는 법적 보존 기간까지.
    3. **서비스 이용 과정에서 자동 수집되는 정보**:
        - 수집 항목: IP 주소, 쿠키, 방문 일시, 불량 이용 기록, 기기 정보(PC/모바일).
        - 수집 목적: 서비스 이용 분석, 보안 관리, 맞춤형 서비스 제공.
2. **개인정보 수집 방법**:
    - FLEXPACE 모바일 앱을 통한 회원가입, 고객센터 상담, 이벤트 참여 시 오프라인 수집.
''',
    },
    {
      'title': "제2조 (개인정보 이용 목적)",
      'contents': '''
회사는 수집된 개인정보를 다음의 목적으로 이용합니다:

1. **회원 관리**: 회원제 서비스 제공, 개인식별, 이용약관 위반 회원에 대한 조치, 고지사항 전달 등.
2. **서비스 제공 및 관리**: 공간 예약, 회원 맞춤형 서비스 제공.
3. **마케팅 및 광고**: 이벤트 정보 제공, 프로모션 및 광고 안내.
4. **보안 및 안전 관리**: 서비스의 안전한 운영 및 회원 보호.
''',
    },
    {
      'title': "제3조 (개인정보의 제공)",
      'contents': '''
1. 회사는 회원의 개인정보를 사전 동의 없이 외부에 공개하지 않습니다. 다만, 법적 요구 사항에 따라 수사기관의 요청이 있는 경우 예외로 합니다.
2. 게스트회원의 공간 예약 및 이용과정에서 개인정보가 호스트회원에게 제공될 수 있습니다.
''',
    },
    {
      'title': "제4조 (회원의 권리·의무 및 행사방법)",
      'contents': '''
1. 회원은 언제든지 자신의 개인정보 조회, 수정, 가입해지를 요청할 수 있으며, 회사는 이에 대해 지체 없이 조치합니다.
2. 회원의 개인정보 오류 정정 요청 시, 정정이 완료될 때까지 해당 개인정보의 이용을 제한합니다.
''',
    },
    {
      'title': "제5조 (개인정보의 보유 및 이용기간)",
      'contents': '''
회사는 회원 탈퇴 또는 개인정보 처리 목적 달성 시 해당 정보를 지체 없이 파기합니다. 법령에 따른 보관 기간은 아래와 같습니다:

- 계약 또는 청약 철회 기록: 5년 보관.
- 대금 결제 및 재화 공급 기록: 5년 보관.
- 소비자 불만 또는 분쟁 처리 기록: 3년 보관.
''',
    },
    {
      'title': "제6조 (개인정보의 파기)",
      'contents': '''
회사는 개인정보의 수집 및 이용 목적이 달성된 후 해당 정보를 복구가 불가능한 방법으로 파기합니다.
''',
    },
    {
      'title': "제7조 (개인정보의 기술적/관리적 보호조치)",
      'contents': '''
회사는 개인정보의 안전성을 확보하기 위해 다음과 같은 조치를 취하고 있습니다:

- 관리적 조치: 내부 관리계획 수립, 직원 교육.
- 기술적 조치: 접근 통제 시스템 설치, 개인정보 암호화.
- 물리적 조치: 자료 보관실의 접근 통제.
''',
    },
    {
      'title': "제8조 (개인정보 관리책임자의 연락처)",
      'contents': '''
회원은 아래의 연락처로 개인정보 관련 문의를 하실 수 있습니다:

- 개인정보 관리책임자: 고재찬, 연락처: 010-2911-9815, 이메일: chan@jinpia.site

기타 개인정보 침해에 대한 피해구제, 상담 등을 아래의 기관에 문의하실 수 있습니다.

(아래의 기관은 회사와는 별개의 기관으로서, 회사의 자체적인 개인정보 불만처리, 피해구제 결과에 만족하지 못하시거나 보다 자세한 도움이 필요하시면 문의하여 주시기 바랍니다.)

- 개인정보침해신고센터 ([privacy.kisa.or.kr](http://privacy.kisa.or.kr/) / 국번없이 118 )
- 대검찰청 사이버수사과 ([www.spo.go.kr](http://www.spo.go.kr/) / 국번없이 1301 )
- 경찰청 사이버안전국 ([www.ctrc.go.kr](http://www.ctrc.go.kr/) / 국번없이 182 )
''',
    },
    {
      'title': "제9조 (개인정보처리방침 변경 및 고지의무)",
      'contents': '''
회사는 개인정보처리방침 변경 시 최소 7일 전에 공지사항을 통해 고지합니다. 본 방침은 2024년 10월 1일부터 적용됩니다.
''',
    },
  ];
}
