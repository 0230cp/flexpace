import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

//백그라운드, 터미널에서 알림을 받을 수 있게 해줌
Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FirebasePush extends GetxController {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  RemoteMessage? foregroundMessage;

  late AndroidInitializationSettings initialzationSettingsAndroid;
  late DarwinInitializationSettings initialzationSettingsIOS;


  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    importance: Importance.max,
  );

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void onInit() async {
    getFCMToken();
    setAlarm();
    foregroundFCMListeners();
    backgroundFCMListeners();
    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
    super.onInit();
  }

  setAlarm() async {
    // android setting
    await androidSetting();

    // ios setting
    await iosSetting();

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(android: AndroidInitializationSettings('@mipmap/ic_launcher'), iOS: DarwinInitializationSettings()),
      onDidReceiveNotificationResponse: (NotificationResponse notificationResponse) async {
        //포어그라운드 클릭시 이벤트 처리하고 싶을 때 사용
        _checkMessage(foregroundMessage);
      },
    );
  }

  // fcm token을 불러옴
  getFCMToken() async {
    String? token = await _messaging.getToken();
    try {
      print(token);
    } catch (e) {
      print(e);
    }
    return _messaging.getToken();
  }

  Future<void> androidSetting() async {
    // android - 채널 세팅
    await _flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(_channel);
    // android 초기화
    initialzationSettingsAndroid = const AndroidInitializationSettings('@mipmap/ic_launcher'); // @mipmap/ic_launcher : push 수신시, 표시될 아이콘
  }

  Future<void> iosSetting() async {
    // iOS - 알림 권한 요청
    await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    // ios - 소리, 뱃지, 알림창 허용 여부
    initialzationSettingsIOS = const DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
  }

  // foreground 리스너 (포어그라운드일경우 수신부)
  void foregroundFCMListeners() async {
    // app foreground시 수신부
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      foregroundMessage = message;
      _showLocalMessage(message);
    });
  }

  Future<void> backgroundFCMListeners() async {
    // app terminated인 경우 수신부
    FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) async {
      _checkMessage(message);
    });

    // app background인 경우 수신부
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      //local notification
      _checkMessage(message);
    });
  }

  //포어그라운드 알림 올 시 local notification으로 알림 출력, (백그라운드는 fcm측에서 전송하는걸로, 핸들러만 등록해놓으면 됨)
  Future<dynamic> onSelectNotification(payload) async {}
  _showLocalMessage(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            _channel.id,
            _channel.name,
            channelDescription: _channel.description,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  //이벤트 처리하고 싶을때 사용
  _checkMessage(RemoteMessage? message) async {
    
  }
}
