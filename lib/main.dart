import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexpace/common/common.dart';
import 'package:flexpace/common/loader.dart';
import 'package:flexpace/common/service/userdata_service.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

import '../common/secure_storage.dart';
import '../common/service/firebase_options.dart';
import '../route/route.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';


void main() async {
  runZonedGuarded<Future<void>>(() async {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(
    nativeAppKey: '5e4176d6407bf76fdb9d841c7368d40d',
    javaScriptAppKey: '45ee874f27137df493f7a7193cce1fd9',
  );

  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  _requestPermission();

  await FirebaseAuth.instance.signInAnonymously();

  await FirebaseMessaging.instance.getInitialMessage();

  FirebaseMessaging.onBackgroundMessage(backgroundHandler);

  FirebaseMessaging.onBackgroundMessage((message) async {
    print("onBackgroundMessage");
    print(message.data);
  });

  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
    print("onMessageOpenedApp");
    print(message.data);
  });
  FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
    print("onMessage");
    print(message.data);
  });

  await NaverMapSdk.instance.initialize(
      clientId: 'h0wck87ny6',     // 클라이언트 ID 설정
      // onAuthFailed: (e) => log("네이버맵 인증오류 : $e", name: "onAuthFailed")
  );

  if (Platform.isIOS) SecureStorage.getAndroidOptions();
  Get.put(UserDataService());

  await initializeDateFormatting();

  runApp(ScreenUtilInit(
    designSize: const Size(393, 852),
    minTextAdapt: true,
    builder: (context, child) => GetMaterialApp(
        builder: (context, child) {
          return Stack(
            children: [
              MediaQuery(
                //화면마다 각각 다르게 css를 주는 함수
                data: MediaQuery.of(context).copyWith(
                    boldText: false, textScaler: const TextScaler.linear(1.0)),
                child: child!, // child는 null이 아님을 해서 에러 방지 해둠.
              ),
              Obx(
                () => Common.isLoading.value
                    ? Center(
                        child: Container(
                            height: MediaQuery.sizeOf(context).height,
                            width: MediaQuery.sizeOf(context).width,
                            color: Colors.black.withOpacity(0.4),
                            child: const Loader()),
                      )
                    : const SizedBox(),
              )
            ],
          );
        },
        theme: ThemeData(
          fontFamily: 'SUIT',
          canvasColor: Colors.transparent,
          bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent,
            elevation: 0,
            modalElevation: 0,
            modalBarrierColor: Colors.transparent,
            modalBackgroundColor: Colors.transparent,
          ),
        ),
        debugShowCheckedModeBanner: false,
        defaultTransition: Transition.cupertino,
        initialRoute: '/',
        getPages: GetXRouter.route),
  ));
  }, (error, stack) => FirebaseCrashlytics.instance.recordError(error, stack));
}

Future<void> backgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.messageId}");
  return Future.value();
}

Future<void> _requestPermission() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: true,
    badge: true,
    carPlay: true,
    criticalAlert: true,
    provisional: true,
    sound: true,
  );
  print(settings.authorizationStatus);
}
