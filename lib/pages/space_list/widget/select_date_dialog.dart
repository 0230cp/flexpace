import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_calendar.dart';
import 'package:flexpace/global/global_select_box_widget.dart';
import 'package:flexpace/pages/space_list/widget/title_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SelectDateDialog extends StatelessWidget {
  final DateTime focusDate;
  final Function increaseMonth;
  final Function decreaseMonth;
  final Function selectDay;
  final String selectedDate;
  final bool isDate;
  final Function dateTap;
  final double lowerValue;
  final double upperValue;
  final Function(RangeValues) onChanged;
  final String timeRangeText;
  final bool isTime;
  final Function timeTap;
  final Function boxTap;

  const SelectDateDialog({
    super.key,
    required this.focusDate,
    required this.increaseMonth,
    required this.decreaseMonth,
    required this.selectDay,
    required this.selectedDate,
    required this.isDate,
    required this.dateTap,
    required this.lowerValue,
    required this.upperValue,
    required this.onChanged,
    required this.timeRangeText,
    required this.isTime,
    required this.timeTap,
    required this.boxTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const TitleBox(title: '날짜 선택'),
              Padding(
                padding: EdgeInsets.only(
                    top: 32.h, bottom: 24.h, left: 32.w, right: 32.w),
                child: GlobalCalendar(
                  focusDate: focusDate,
                  increaseMonth: () {
                    increaseMonth();
                  },
                  decreaseMonth: () {
                    decreaseMonth();
                  },
                  selectDay: (dateTime) {
                    selectDay(dateTime);
                  },
                  select: selectedDate,
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
                        color: CommonColor.colorF0E68C),
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
              Padding(
                padding: EdgeInsets.only(top: 16.5.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '날짜 무관',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontVariations: CommonStyle.fontWeight500,
                          color: CommonColor.color484848),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    InkWell(
                      onTap: () {
                        dateTap();
                      },
                      child: SvgPicture.asset(isDate
                          ? 'assets/icon/calendar_toggle_on.svg'
                          : 'assets/icon/calendar_toggle_off.svg'),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 1.h,
                margin: EdgeInsets.only(
                    left: 32.w, right: 32.w, top: 24.h, bottom: 36.h),
                decoration: BoxDecoration(color: CommonColor.colorDFDFDF),
              ),
              Padding(
                padding: EdgeInsets.only(left: 32.w, bottom: 12.h),
                child: Text(
                  '시간선택',
                  style: TextStyle(
                      fontSize: 16.sp,
                      fontVariations: CommonStyle.fontWeight800,
                      color: CommonColor.color070707),
                ),
              ),
              isTime
                  ? SizedBox(
                      height: 17.h,
                    )
                  : Center(
                      child: SizedBox(
                        height: 17.h,
                        child: Text(
                          timeRangeText,
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontVariations: CommonStyle.fontWeight600,
                              color: timeRangeText != '드래그로 시간을 설정해주세요'
                                  ? CommonColor.color484848
                                  : CommonColor.colorBFBFBF),
                        ),
                      ),
                    ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    trackHeight: 8.h,
                  ),
                  child: RangeSlider(
                    values: RangeValues(
                      lowerValue,
                      upperValue,
                    ),
                    onChanged: (RangeValues values) {
                      onChanged(values);
                    },
                    min: 0,
                    max: 50,
                    divisions: 50,
                    activeColor: isTime
                        ? CommonColor.colorDDDDDD
                        : CommonColor.colorF0E68C,
                    inactiveColor: CommonColor.colorDDDDDD,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 6.h, bottom: 32.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '시간 무관',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontVariations: CommonStyle.fontWeight500,
                          color: CommonColor.color484848),
                    ),
                    SizedBox(
                      width: 4.w,
                    ),
                    InkWell(
                      onTap: () {
                        timeTap();
                      },
                      child: SvgPicture.asset(isTime
                          ? 'assets/icon/calendar_toggle_on.svg'
                          : 'assets/icon/calendar_toggle_off.svg'),
                    )
                  ],
                ),
              ),
              GlobalSelectBoxWidget(
                text: '날짜 적용하기',
                tap: () {
                  boxTap();
                },
                textColor: isDate || selectedDate.isNotEmpty
                    ? CommonColor.color070707
                    : CommonColor.colorBFBFBF,
                boxColor: isDate || selectedDate.isNotEmpty
                    ? CommonColor.colorF0E68C
                    : CommonColor.colorDDDDDD,
              )
            ],
          ),
        ),
      ),
    );
  }
}
