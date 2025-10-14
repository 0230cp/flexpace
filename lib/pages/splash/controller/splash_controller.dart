import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flexpace/common/secure_storage.dart';
import 'package:flexpace/common/service/userdata_service.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SplashController extends GetxController {
  RxString version = ''.obs;

  @override
  void onInit() {
    autoLogin();
    super.onInit();
  }

  autoLogin() async {
    await const Duration(seconds: 2).delay();
    try {
      User? user = FirebaseAuth.instance.currentUser;

      String userId = await SecureStorage.read(SecureStorageKeys.id);
      if (user != null) {
        var firebaseDoc =
            FirebaseFirestore.instance.collection('user').doc(userId);

        String fcmToken = await FirebaseMessaging.instance.getToken() ?? '';

        var collection = await firebaseDoc.get();
        var data = collection.data();

        if (data != null) {
          UserDataService.to.userData.value = UserModel.fromJson(data);

          String userFcmToken = data['fcmToken']?['token'] ?? '';
          if (userFcmToken != fcmToken) {
            firebaseDoc.update({
              "fcmToken": {
                'token': fcmToken,
                'deviceType': Platform.isIOS ? 'iOS' : 'android'
              },
              "lastAccessTime": DateTime.now(),
            });
            UserDataService.to.userData.value.fcmToken = {
              'token': fcmToken,
              'deviceType': Platform.isIOS ? 'iOS' : 'android'
            };
          }
        }
        Logger().w(UserDataService.to.userData.value.toJson());
      }
      Get.offAllNamed('/main');
    } catch (e) {
      print(" $e");
      Get.offAllNamed('/main');
    }
  }
}
