const functions = require('firebase-functions');
const admin = require('firebase-admin');
const coolsms = require('coolsms-node-sdk').default;

admin.initializeApp();

exports.sendSMS = functions
  .region('asia-northeast3')
  .https.onCall(async (data, context) => {  // onRequest 대신 onCall 사용
    try {
      const { phoneNumber, message } = data;  // req.body 대신 data 사용

      const messageService = new coolsms(
        functions.config().coolsms.api_key,
        functions.config().coolsms.api_secret
      );

      const result = await messageService.sendOne({
        to: phoneNumber,
        from: functions.config().coolsms.sender_number,
        text: message || '안녕하세요! 새로운 메시지가 도착했습니다.'
      });

      console.log('SMS 전송 결과:', result);
      return { success: true, messageId: result.messageId };  // res.json 대신 return 사용
    } catch (error) {
      console.error('SMS 발송 에러:', error);
      throw new functions.https.HttpsError('internal', error.message);
    }
  });