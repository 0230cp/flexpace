import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future<void> sendSMS(
    {required String phoneNumber,
      required String spaceName,
      required String date,
      required  String userNickName,
      required  String userPhoneNumber,}) async {
  try {
    final functions = FirebaseFunctions.instanceFor(
      region: 'asia-northeast3',
    );

    // callable 함수 호출
    final result = await functions
        .httpsCallable('sendSMS')
        .call({
      'phoneNumber': phoneNumber,
      // 'message': '“공간 이름” 예약이 신청되었습니다.\n2024-11-24 / 13:00 ~ 18:00\n닉네임 : jinpia\n휴대폰 번호 : 010-1234-5678'
      'message': '“${spaceName}”공간 예약이 신청되었습니다.\n${date}\n닉네임 : ${userNickName}\n휴대폰 번호 : ${userPhoneNumber}'
    });

    print('SMS 전송 결과: ${result.data}');
  } catch (e) {
    print('SMS 전송 실패: $e');
    rethrow;
  }
}