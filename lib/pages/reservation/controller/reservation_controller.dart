import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexpace/common/common.dart';
import 'package:flexpace/common/send_sms.dart';
import 'package:flexpace/common/service/userdata_service.dart';
import 'package:flexpace/global/global_bottom_notification_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class ReservationController extends GetxController {
  RxList<int> sortedHours = <int>[].obs;
  RxString selectedDate = ''.obs;
  RxMap<String, int> selectionRange = RxMap({'start': -1, 'end': -1});
  RxBool isFirstSelection = true.obs;
  RxString formattedReservation = ''.obs; // 포맷된 예약 정보를 저장할 변수 추가
  Rx<DateTime?> startDateTime = Rx<DateTime?>(null);
  Rx<DateTime?> endDateTime = Rx<DateTime?>(null);

  void calculateReservationDateTime() {
    if (selectedDate.value.isEmpty || sortedHours.isEmpty) {
      startDateTime.value = null;
      endDateTime.value = null;
      return;
    }

    DateTime baseDate = DateFormat('yyyy-MM-dd').parse(selectedDate.value);

    // 시작 시간과 종료 시간 계산
    int startHour = sortedHours.first;
    int endHour = sortedHours.last + 1;

    startDateTime.value = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      startHour,
      0,
    );

    endDateTime.value = DateTime(
      baseDate.year,
      baseDate.month,
      baseDate.day,
      endHour,
      0,
    );
  }

  // 총 가격을 계산하는 함수
  void calculateTotalPrice() {
    int sum = 0;
    for (int hour in sortedHours) {
      sum += priceList[hour];
    }
    totalPrice.value = sum;
  }

  String formatHour(int hour) {
    return '$hour:00';
  }

  void updateFormattedReservation() {
    if (selectedDate.value.isNotEmpty && sortedHours.isNotEmpty) {
      final start = sortedHours.first;
      final end = sortedHours.last + 1;
      final duration = end - start;

      formattedReservation.value = '${selectedDate.value}, '
          '${formatHour(start)}~${formatHour(end)} '
          '(${duration}시간)';
    } else {
      formattedReservation.value = '';
    }
  }

  void handleTimeSelection(int index) {
    if(blockHours.contains(index)){
      return;
    }

    if (isFirstSelection.value) {
      selectionRange['start'] = index;
      selectionRange['end'] = index;
      isFirstSelection.value = false;
      updateSelectedHours();
    } else {
      // 시작과 끝 사이의 범위 체크
      final start = min(selectionRange['start']!, index);
      final end = max(selectionRange['start']!, index);

      // 범위 내에 blockHours가 있는지 확인
      for (int i = start; i <= end; i++) {
        if (blockHours.contains(i)) {
          // block이 포함되어 있으면 선택 취소
          Get.showSnackbar(Common.getSnackBar('예약이 불가능한 시간입니다.'));

          clearSelection();
          return;
        }
      }

      selectionRange['end'] = index;
      updateSelectedHours();
      isFirstSelection.value = true;
    }
    updateFormattedReservation();
    calculateTotalPrice();
    calculateReservationDateTime();
  }

  void updateSelectedHours() {
    sortedHours.clear();
    final start = min(selectionRange['start']!, selectionRange['end']!);
    final end = max(selectionRange['start']!, selectionRange['end']!);

    for (int i = start; i <= end; i++) {
      sortedHours.add(i);
    }
  }

  void clearSelection() {
    selectionRange['start'] = -1;
    selectionRange['end'] = -1;
    isFirstSelection.value = true;
    sortedHours.clear();
    totalPrice.value = 0; // 선택 초기화시 총 가격도 초기화
    updateFormattedReservation();
  }

  //
  Rx<DateTime> focusDate = DateTime.now().obs;

  RxMap spaceDetail = {}.obs;

  RxList selectedPrice = [].obs;

  List<int> priceList = [];

  RxList dayList = [].obs;

  RxInt totalPrice = 0.obs;

  updateReserve() async {
    if (totalPrice.value <= 0 || endDateTime.value ==null || startDateTime.value == null ) {
      Get.showSnackbar(Common.getSnackBar('예약 시간을 선택해주세요.'));
      return;
    }

    try {
      Common.isLoading.value = true;
      Map<String, dynamic> requestData = {
        'createAt': DateTime.now(),
        'price': totalPrice.value,
        'reserveEnd': endDateTime.value,
        'reserveStart': startDateTime.value,
        'spaceId': spaceDetail['docId'],
        'status': '예약확정',
        'userId': UserDataService.to.userData.value.docId
      };

      final FirebaseFirestore firestore = FirebaseFirestore.instance;

      DocumentReference docRef =
          await firestore.collection('reserve').add(requestData);
      String docId = docRef.id;
      await docRef.update({'docId': docId});

      await sendReservationSms();

      Common.isLoading.value = false;

      Get.bottomSheet(GlobalBottomNotificationWidget(
        tap: () {
          Get.close(0);
          Get.offAllNamed('/main');
        },
        isRequest: true,
      ));

    } catch (e) {
      print(e);
    } finally{
      Common.isLoading.value = false;
    }
  }

  sendReservationSms() {
    sendSMS(
      phoneNumber: spaceDetail['phoneNumber'],
      //매장 폰번호
      spaceName: spaceDetail['title'],
      //매장 이름
      date: formattedReservation.value,
      //매장 날짜
      userNickName: UserDataService.to.userData.value.nickName.toString(),
      //예약한 유저 닉넴
      userPhoneNumber:
          UserDataService.to.userData.value.phoneNumber.toString(), //예약한 유저 폰번호
    );
  }

  defaultPriceAdd() {
    for (int i = 0; i < 24; i++) {
      priceList.add(spaceDetail['defaultPrice']);
    }
  }

  selectDayData(DateTime data) async {
    if (!Common.isPreviousDate(data) || Common.isToday(data)) {
      selectedDate.value = DateFormat('yyyy-MM-dd', 'ko_KR').format(data);
    }
    Logger().w(selectedDate.value);
    await getDay(selectedDate.value);
    blockHours.value = getAllReservedHours(dayList);
  }

  getDay(String selectedDate) async {
    DateTime date = DateTime.parse(selectedDate);

    DateTime startOfDay = DateTime(date.year, date.month, date.day);

    DateTime endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    QuerySnapshot doc = await FirebaseFirestore.instance
        .collection('reserve')
        .where('spaceId', isEqualTo: spaceDetail['docId'])
        .where('reserveStart', isGreaterThanOrEqualTo: startOfDay)
        .where('reserveEnd', isLessThanOrEqualTo: endOfDay)
        .get();

    dayList.clear();

    dayList.addAll(doc.docs.map((doc) => doc.data()));

    Logger().e(dayList);
  }

  List<int> getAllReservedHours(List reservations) {
    Set<int> hours = {};

    for (var reservation in reservations) {
      DateTime startTime = (reservation['reserveStart'] as Timestamp).toDate();
      DateTime endTime = (reservation['reserveEnd'] as Timestamp).toDate();

      print(startTime);
      print(endTime);

      //마지막 시간은 제외
      for (int hour = startTime.hour; hour <= endTime.hour-1; hour++) {
        hours.add(hour);
      }
    }

    List<int> blockHours = hours.toList()..sort();
    Logger().w(blockHours);

    return blockHours;
  }

  RxList blockHours = [].obs;

  String conversion(String selectedDate) {
    return DateFormat('yyyy.MM.dd(E)', 'ko_KR')
        .format(DateTime.parse(selectedDate));
  }

  @override
  void onInit() {
    spaceDetail = Get.arguments;
    defaultPriceAdd();
    ever(selectedDate, (_) => updateFormattedReservation());
    Logger().w(spaceDetail);
    super.onInit();
  }
}
