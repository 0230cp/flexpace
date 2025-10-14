import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flexpace/common/common.dart';
import 'package:flexpace/pages/space_list/widget/people_dialog.dart';
import 'package:flexpace/pages/space_list/widget/region_dialog.dart';
import 'package:flexpace/pages/space_list/widget/select_date_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

class SpaceListController extends GetxController {
  List<String> menu = ['전체지역', '인원', '날짜'];

  RxString selectedMenu = '전체지역'.obs;

  RxBool isDate = false.obs;

  RxBool isTime = false.obs;

  String type = '';

  RxString region = '서울'.obs;

  RxString regionType = ''.obs;

  RxString people = ''.obs;

  Rx<DateTime> focusDate = DateTime.now().obs;

  RxString selectedDate = ''.obs;

  RxString timeRangeText = '드래그로 시간을 설정해주세요'.obs;

  RxDouble lowerValue = 0.0.obs;
  RxDouble upperValue = 50.0.obs;

  RxList spaceList = [].obs;

  Map<String, List> regionList = {
    '전체지역': [],
    '서울': [
      '서울 전체',
      '강남∙역삼∙선릉∙삼성',
      '서초∙교대∙방배',
      '성수∙왕십리∙서울숲',
      '종로∙광화문∙대학로',
      '용산∙이태원∙한남',
      '광진∙건대∙구의∙군자',
      '성북∙성신여대∙안암',
      '도곡∙대치∙개포∙수서',
      '구로∙신도림∙고척',
      '강동∙성내∙천호∙길동',
      '양천∙목동∙신정',
      '노원∙상계∙공릉',
      '중랑∙상봉∙면목',
      '홍대∙함정∙상수∙연남',
      '마포∙공덕∙아현',
      '영등포∙여의도∙당산',
      '신림∙봉천∙서울대입구',
      '회기∙고려대∙청량리',
      '방이∙잠실∙송파',
      '신사∙논현∙청담∙압구정'
    ],
    '경기': [
      '경기 전체',
      '수원∙영통∙인계∙팔달',
      '성남∙분당∙판교',
      '일산∙킨텍스∙주엽',
      '용인∙기흥∙수지',
      '안양∙평촌∙범계∙과천'
    ]
  };

  List<String> peopleList = [
    '10인',
    '15인',
    '20인',
    '30인',
    '40인',
    '80인',
    '100인',
    '200인'
  ];

  /// 전체 불러오기
  getSpace() async {
    final QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('space')
        .where('type', isEqualTo: type)
        .where('isDelete', isEqualTo: false)
        .get();

    spaceList.clear();

    spaceList.addAll(doc.docs.map((doc) => doc.data()));

    Logger().w('Space List: $spaceList');
  }

  /// 지역 선택
  selectetRegion(String item) {
    region.value = item;
    if (item.contains('전체지역')) {
      return regionType.value = '전체지역';
    }

    regionType.value = '';
  }

  selectedRegionType(int index) {
    regionType.value = regionList[region.value]![index];
  }

  getLocation(String regionType, String location) async {
    print(regionType);

    if (regionType.contains('전체')) {
      final QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('space')
          .where('type', isEqualTo: type)
          .where('isDelete', isEqualTo: false)
          .where('totalLocation', isEqualTo: regionType)
          .get();
      return doc;
    } else {
      final QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
          .instance
          .collection('space')
          .where('type', isEqualTo: type)
          .where('isDelete', isEqualTo: false)
          .where('subway', arrayContains: location)
          .get();
      return doc;
    }
  }

  /// 인원 선택
  getRegionSpace() async {
    if (regionType.value.isEmpty) {
      return;
    }
    List<String> locationList = regionType.value.split('∙');

    final QuerySnapshot<Map<String, dynamic>> doc =
        await getLocation(regionType.value, locationList[0]);

    spaceList.clear();

    spaceList.addAll(doc.docs.map((doc) => doc.data()));

    Logger().w('Space List: $spaceList');

    update();

    Get.back();
  }

  /// 인원 선택
  selectedPeopleType(int index) {
    people.value = peopleList[index];
  }

  getPeopleSpace() async {
    if (people.value.isEmpty) {
      return;
    }

    String numberOnly = people.value.replaceAll('인', '');

    int maxPeople = int.parse(numberOnly);

    final QuerySnapshot<Map<String, dynamic>> doc = await FirebaseFirestore
        .instance
        .collection('space')
        .where('type', isEqualTo: type)
        .where('isDelete', isEqualTo: false)
        .where('maximum', isGreaterThanOrEqualTo: maxPeople)
        .orderBy('maximum')
        .get();

    spaceList.clear();

    spaceList.addAll(doc.docs.map((doc) => doc.data()));

    Logger().w('Space List: $spaceList');

    update();

    Get.back();
  }

  /// 날짜 선택
  noSpecificDate() {
    isDate.value = !isDate.value;

    if (isDate.value) {
      selectedDate.value = '';
      isTime.value = true;
    } else {
      isTime.value = false;
    }
  }

  noSpecificTime() {
    if (isDate.value) {
      return;
    }

    isTime.value = !isTime.value;
  }

  updateTimeRange(RangeValues values) {
    lowerValue.value = values.start;
    upperValue.value = values.end;
    updateTimeRangeText();
  }

  lowerData() {
    int startHour = (lowerValue.value / 2.0833).floor();
    return startHour;
  }

  upperData() {
    int startHour = (upperValue.value / 2.0833).floor();
    return startHour;
  }

  updateTimeRangeText() {
    int startHour = lowerData();
    int endHour = upperData();

    if ((startHour == 0 && endHour >= 23) ||
        (lowerValue.value == 0 && upperValue.value == 50)) {
      timeRangeText.value = '드래그로 시간을 설정해주세요';
      return;
    }

    String startTime = startHour.toString().padLeft(2, '0');
    String endTime = endHour.toString().padLeft(2, '0');

    timeRangeText.value = '$startTime시 ~ $endTime시';
  }

  getPeopleDate() async {
    if (isDate.value) {
      await getSpace();
      update();

      Get.back();
      return;
    }

    if (selectedDate.value.isEmpty) {
      return Get.showSnackbar(Common.getSnackBar('날짜를 선택해 주세요.'));
    }

    int startHour = lowerData();
    int endHour = upperData();

    DateTime date = DateTime.parse(selectedDate.value);
    DateTime startDate =
        DateTime(date.year, date.month, date.day, startHour, 0);
    DateTime endDate = DateTime(date.year, date.month, date.day, endHour, 0);

    QuerySnapshot spaceSnapshot = await FirebaseFirestore.instance
        .collection('space')
        .where('type', isEqualTo: type)
        .where('isDelete', isEqualTo: false)
        .get();

    List<DocumentSnapshot> availableSpaces = [];

    for (var space in spaceSnapshot.docs) {
      QuerySnapshot reservationSnapshot = await FirebaseFirestore.instance
          .collection('reserve')
          .where('spaceId', isEqualTo: space.id)
          .get();

      // 예약이 하나도 없으면 사용 가능
      if (reservationSnapshot.docs.isEmpty) {
        availableSpaces.add(space);
        continue;
      }

      // 시간대별로 예약 상태를 체크
      List<DateTime> allReservationTimes = [];

      // 모든 예약의 시작과 끝 시간을 수집
      for (var doc in reservationSnapshot.docs) {
        DateTime reserveStart = (doc['reserveStart'] as Timestamp).toDate();
        DateTime reserveEnd = (doc['reserveEnd'] as Timestamp).toDate();

        // 검색 범위와 관련 있는 예약만 고려
        if (reserveEnd.isAfter(startDate) && reserveStart.isBefore(endDate)) {
          allReservationTimes.add(reserveStart);
          allReservationTimes.add(reserveEnd);
        }
      }

      if (allReservationTimes.isEmpty) {
        availableSpaces.add(space);
        continue;
      }

      // 시간순으로 정렬
      allReservationTimes.sort();

      // 예약된 시간들 사이에 1시간 이상의 간격이 있는지 확인
      bool hasAvailableSlot = false;

      // 검색 시작시간부터 첫 예약 시작까지 확인
      if (allReservationTimes.first.difference(startDate).inHours >= 1) {
        hasAvailableSlot = true;
      }

      // 마지막 예약 끝부터 검색 종료시간까지 확인
      if (endDate.difference(allReservationTimes.last).inHours >= 1) {
        hasAvailableSlot = true;
      }

      // 예약들 사이의 간격 확인
      for (int i = 0; i < allReservationTimes.length - 1; i += 2) {
        if (allReservationTimes[i + 1].isBefore(endDate) &&
            (i + 2 < allReservationTimes.length) &&
            allReservationTimes[i + 2]
                    .difference(allReservationTimes[i + 1])
                    .inHours >=
                1) {
          hasAvailableSlot = true;
          break;
        }
      }

      if (hasAvailableSlot) {
        availableSpaces.add(space);
      }
    }
    spaceList.clear();

    for (var doc in availableSpaces) {
      Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
      spaceList.add(data);
    }

    update();

    Get.back();

    Logger().w(spaceList);
  }

  /// 카테고리 선택
  selectedMenuDialog(String menu) {
    switch (menu) {
      case '전체지역':
        return Get.dialog(Obx(
          () => RegionDialog(
            regionList: regionList,
            regionType: regionType.value,
            region: region.value,
            regionTap: (String item) {
              selectetRegion(item);
            },
            regionListTap: (index) {
              selectedRegionType(index);
            },
            boxTap: () async {
              if (regionType.value == '전체지역') {
                await getSpace();
                update();

                Get.back();
              } else {
                await getRegionSpace();
              }
            },
          ),
        ));

      case '인원':
        return Get.dialog(Obx(
          () => PeopleDialog(
            peopleList: peopleList,
            people: people.value,
            tap: (index) {
              selectedPeopleType(index);
            },
            boxTap: () {
              getPeopleSpace();
            },
          ),
        ));

      case '날짜':
        return Get.dialog(Obx(
          () => SelectDateDialog(
            focusDate: focusDate.value,
            increaseMonth: () {
              focusDate.value = Common.increaseMonth(focusDate);
            },
            decreaseMonth: () {
              focusDate.value = Common.decreaseMonth(focusDate);
            },
            selectDay: (dateTime) {
              if (!Common.isPreviousDate(dateTime) ||
                  Common.isToday(dateTime)) {
                selectedDate.value =
                    DateFormat('yyyy-MM-dd', 'ko_KR').format(dateTime);
              }
            },
            selectedDate: selectedDate.value,
            isDate: isDate.value,
            dateTap: () {
              noSpecificDate();
            },
            lowerValue: lowerValue.value,
            upperValue: upperValue.value,
            onChanged: (values) {
              if (isTime.value) {
                return;
              }

              updateTimeRange(values);
              if (values.start < upperValue.value) {
                lowerValue.value = values.start;
              }
              if (values.end > lowerValue.value) {
                upperValue.value = values.end;
              }
            },
            timeRangeText: timeRangeText.value,
            isTime: isTime.value,
            timeTap: () {
              noSpecificTime();
            },
            boxTap: () {
              getPeopleDate();
            },
          ),
        ));

      default:
        break;
    }
  }

  @override
  Future<void> onInit() async {
    type = Get.arguments;
    await getSpace();
    super.onInit();
  }
}
