import 'package:flexpace/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GlobalCalendar extends StatelessWidget {
  final DateTime focusDate;
  final Function increaseMonth;
  final Function decreaseMonth;
  final Function selectDay;
  final String select;
  final Color? boxColor;
  final Color? textColor;

  GlobalCalendar(
      {super.key,
      required this.focusDate,
      required this.increaseMonth,
      required this.decreaseMonth,
      required this.selectDay,
      required this.select,
      this.boxColor,
      this.textColor});

  final List<String> weekDays = ['일', '월', '화', '수', '목', '금', '토'];
  final DateTime todayMidnight =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    int monthInDays = DateUtils.getDaysInMonth(focusDate.year, focusDate.month);
    int offset = DateTime(focusDate.year, focusDate.month, 1).weekday % 7;
    DateTime selectedDate =
        select.isEmpty ? DateTime.now() : DateTime.parse(select);

    List<Widget> gridCells = [];
    List<Widget> weekDayCells = [];

    for (int i = 0; i < 7; i++) {
      weekDayCells.add(SizedBox(
        width: 18.w,
        child: Center(
          child: Text(
            weekDays[i],
            style: TextStyle(
                color: i == 6
                    ? CommonColor.color1770C2
                    : i == 0
                        ? const Color(0xffFF6A74)
                        : CommonColor.color626262,
                fontSize: 14.sp,
                fontVariations: CommonStyle.fontWeight600),
          ),
        ),
      ));
    }
    for (int i = 0; i < offset; i++) {
      gridCells.add(Container());
    }
    for (int i = 1; i <= monthInDays; i++) {
      DateTime dateTime = DateTime(focusDate.year, focusDate.month, i);
      bool isSunday = dateTime.weekday == DateTime.sunday;
      bool isSaturday = dateTime.weekday == DateTime.saturday;

      gridCells.add(select.isNotEmpty && dateTime == selectedDate
          ? InkWell(
              onTap: () {
                selectDay(dateTime);
              },
              child: Container(
                width: 32.w,
                height: 32.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: boxColor ?? CommonColor.colorF0E68C),
                child: Center(
                  child: Text(
                    '$i',
                    style: TextStyle(
                        color: textColor ?? CommonColor.color070707,
                        fontSize: 14.sp,
                        fontVariations: CommonStyle.fontWeight600),
                  ),
                ),
              ),
            )
          : dateTime == todayMidnight
              ? InkWell(
                  onTap: () {
                    selectDay(dateTime);
                  },
                  child: Container(
                    width: 32.w,
                    height: 32.w,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: CommonColor.colorDDDDDD),
                    child: Center(
                      child: Text(
                        '$i',
                        style: TextStyle(
                            color: CommonColor.color070707,
                            fontSize: 14.sp,
                            fontVariations: CommonStyle.fontWeight600),
                      ),
                    ),
                  ),
                )
              : InkWell(
                  onTap: () {
                    selectDay(dateTime);
                  },
                  child: SizedBox(
                    width: 32.w,
                    height: 32.w,
                    child: Center(
                      child: Text(
                        '$i',
                        style: TextStyle(
                            color: isSunday
                                ? const Color(0xffFF6A74)
                                : isSaturday
                                    ? CommonColor.color1770C2
                                    : CommonColor.color070707,
                            fontSize: 14.sp,
                            fontVariations: CommonStyle.fontWeight600),
                      ),
                    ),
                  ),
                ));
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
                onTap: () {
                  decreaseMonth();
                },
                child: SvgPicture.asset('assets/icon/left_polygon.svg')),
            Padding(
              padding: EdgeInsets.only(left: 36.w),
              child: Text(
                '${focusDate.year}년',
                style: TextStyle(
                    fontSize: 20.sp,
                    color: CommonColor.color070707,
                    fontVariations: CommonStyle.fontWeight700),
              ),
            ),
            SizedBox(
              width: 12.w,
            ),
            Padding(
              padding: EdgeInsets.only(right: 36.w),
              child: Text(
                '${focusDate.month}월',
                style: TextStyle(
                    fontSize: 20.sp,
                    color: CommonColor.color070707,
                    fontVariations: CommonStyle.fontWeight700),
              ),
            ),
            InkWell(
                onTap: () {
                  increaseMonth();
                },
                child: SvgPicture.asset('assets/icon/right_polygon.svg')),
          ],
        ),
        SizedBox(
          height: 16.h,
        ),
        GridView.count(
          crossAxisCount: 7,
          primary: false,
          shrinkWrap: true,
          mainAxisSpacing: 36.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 1,
          children: weekDayCells,
        ),
        GridView.count(
          crossAxisCount: 7,
          primary: false,
          shrinkWrap: true,
          mainAxisSpacing: 6.h,
          crossAxisSpacing: 8.w,
          childAspectRatio: 1,
          children: gridCells,
        )
      ],
    );
  }
}
