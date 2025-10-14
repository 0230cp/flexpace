import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_bottom_notification_widget.dart';
import 'package:flexpace/global/global_business_info_widget.dart';
import 'package:flexpace/global/global_button_widget.dart';
import 'package:flexpace/global/global_calendar.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/pages/reservation/controller/reservation_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../global/global_layout_widget.dart';

class ReservationViewPage extends GetView<ReservationController> {
  const ReservationViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        drawer: GlobalSidebarWidget(),
        appBar: const GlobalAppbarWidget(),
        bottomNavigationBar: InkWell(
          onTap: () {
            controller.updateReserve();

          },
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            height: 56.h,
            decoration: BoxDecoration(color: CommonColor.color1770C2),
            child: Center(
              child: Text(
                '예약 신청',
                style: TextStyle(
                    fontSize: 20.sp,
                    fontVariations: CommonStyle.fontWeight600,
                    color: Colors.white),
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(
                    left: 24.w, right: 24.w, top: 20.h, bottom: 12.h),
                decoration: BoxDecoration(
                  color: CommonColor.colorF0E68C,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                child: Text(
                  '최대 수용 인원 ${controller.spaceDetail['maximum']}명',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontVariations: CommonStyle.fontWeight800,
                    color: CommonColor.color1770C2,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  controller.spaceDetail['title'],
                  style: CommonStyle.titleTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 24.w, right: 24.w, top: 8.h, bottom: 24.h),
                child: Text(
                  '[${Common.formattedSubway(controller.spaceDetail['subway'])}] ${controller.spaceDetail['subTitle']}',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontVariations: CommonStyle.fontWeight700,
                      color: CommonColor.color626262),
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 1.h,
                margin: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 40.h),
                decoration: const BoxDecoration(color: Color(0xffD9D9D9)),
              ),
              underscoreText('날짜 선택'),
              Padding(
                padding: EdgeInsets.only(
                    top: 32.h, bottom: 20.h, left: 32.w, right: 32.w),
                child: Obx(
                  () => GlobalCalendar(
                    focusDate: controller.focusDate.value,
                    boxColor: CommonColor.color1770C2,
                    textColor: Colors.white,
                    increaseMonth: () {
                      controller.focusDate.value =
                          Common.increaseMonth(controller.focusDate);
                    },
                    decreaseMonth: () {
                      controller.focusDate.value =
                          Common.decreaseMonth(controller.focusDate);
                    },
                    selectDay: (dateTime) {
                      controller.selectDayData(dateTime);
                    },
                    select: controller.selectedDate.value,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10.h,
                    height: 10.h,
                    margin: EdgeInsets.only(right: 4.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: CommonColor.colorDDDDDD),
                  ),
                  Text(
                    '오늘',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontVariations: CommonStyle.fontWeight500,
                        color: CommonColor.color484848),
                  ),
                  Container(
                    width: 10.h,
                    height: 10.h,
                    margin: EdgeInsets.only(left: 12.w, right: 4.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: CommonColor.color1770C2),
                  ),
                  Text(
                    '선택한 날짜',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontVariations: CommonStyle.fontWeight500,
                        color: CommonColor.color484848),
                  )
                ],
              ),
              underscoreText('시간 선택'),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  controller.priceList.length,
                      (index) => GestureDetector(
                    onTap: () => controller.handleTimeSelection(index),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          index == 0 ? '' : '$index',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontVariations: CommonStyle.fontWeight600,
                          ),
                        ),
                        Obx(
                              () => Container(
                            width: 64.w,
                            height: 41,
                            decoration: BoxDecoration(
                              color:
                              controller.blockHours.contains(index)
                                ? CommonColor.color626262
                              : controller.sortedHours.contains(index)
                                  ? CommonColor.colorF5F5F5
                                  : Colors.white,
                              border: Border.all(
                                width: 1.r,
                                color: controller.blockHours.contains(index)
                                    ? CommonColor.color484848
                                    : controller.sortedHours.contains(index)
                                    ? CommonColor.color1770C2  // 선택된 경우 강조색
                                    : CommonColor.colorDDDDDD,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                Common.getFormattedNumber(
                                  '${controller.priceList[index]}',
                                ),
                                style: TextStyle(
                                  color: controller.blockHours.contains(index)
                                      ? CommonColor.colorBFBFBF
                                      : controller.sortedHours.contains(index)
                                      ? CommonColor.color1770C2  // 선택된 경우 강조색
                                      : Colors.black,
                                  fontSize: 14.sp,
                                  fontVariations: CommonStyle.fontWeight600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // 선택 초기화 버튼 (옵션)
            Padding(
              padding: EdgeInsets.only(top: 16.h),
              child: TextButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CommonColor.color1770C2)),
                onPressed: () => controller.clearSelection(),

                child: Text('선택 초기화',style: TextStyle(color: Colors.white,                        fontVariations: CommonStyle.fontWeight500,
                ),),
              ),
            ),
          ],
        ),
      ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 10.h,
                    height: 10.h,
                    margin: EdgeInsets.only(right: 4.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: CommonColor.colorDDDDDD),
                  ),
                  Text(
                    '선택불가',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontVariations: CommonStyle.fontWeight500,
                        color: CommonColor.color484848),
                  ),
                  Container(
                    width: 10.h,
                    height: 10.h,
                    margin: EdgeInsets.only(right: 4.w, left: 12.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        border: Border.all(
                            width: 1.r, color: CommonColor.colorBFBFBF)),
                  ),
                  Text(
                    '가능한시간',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontVariations: CommonStyle.fontWeight500,
                        color: CommonColor.color484848),
                  ),
                  Container(
                    width: 10.h,
                    height: 10.h,
                    margin: EdgeInsets.only(left: 12.w, right: 4.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: CommonColor.color1770C2),
                  ),
                  Text(
                    '선택한 날짜',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontVariations: CommonStyle.fontWeight500,
                        color: CommonColor.color484848),
                  )
                ],
              ),
              SizedBox(
                height: 56.h,
              ),
              underscoreText('예약 일시'),
              Padding(
                padding: EdgeInsets.only(
                    left: 24.w, right: 24.w, top: 24.h, bottom: 63.h),
                child: Obx(
                  () => Text(
                    controller.formattedReservation.value.isNotEmpty
                        ? controller.formattedReservation.value
                        : '예약 일시가 선택되지 않았습니다.',
                    style: TextStyle(
                        fontSize: controller.selectedDate.value.isNotEmpty
                            ? 16.sp
                            : 14.sp,
                        fontVariations: CommonStyle.fontWeight500,
                        color: controller.selectedDate.value.isNotEmpty
                            ? CommonColor.color070707
                            : CommonColor.color626262),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 1.h,
                margin: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
                decoration: const BoxDecoration(color: Color(0xffD9D9D9)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 24.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '공간사용료',
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontVariations: CommonStyle.fontWeight700,
                          color: CommonColor.color626262),
                    ),
                 Obx(() =>    Text(
                     '${Common.getFormattedNumber('${controller.totalPrice.value}')} 원',
                      style: TextStyle(
                          fontSize: 20.sp,
                          fontVariations: CommonStyle.fontWeight500,
                          color: CommonColor.color070707),
                    )),
                  ],
                ),
              ),
              const GlobalBusinessInfoWidget(),
            ],
          ),
        ));
  }
}

Widget underscoreText(String text) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          text,
          style: TextStyle(
              fontSize: 20.sp,
              fontVariations: CommonStyle.fontWeight800,
              color: CommonColor.color1770C2),
        ),
        Container(
          width: double.infinity,
          height: 2.h,
          margin: EdgeInsets.only(top: 12.h),
          decoration: BoxDecoration(color: CommonColor.color1770C2),
        ),
      ],
    ),
  );
}
