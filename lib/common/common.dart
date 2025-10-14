import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class CommonColor {
  static Color color1770C2 = const Color(0xff1770C2);
  static Color color070707 = const Color(0xff070707);
  static Color colorBFBFBF = const Color(0xffBFBFBF);
  static Color colorDFDFDF = const Color(0xffDFDFDF);
  static Color colorF0E68C = const Color(0xffF0E68C);
  static Color color7A7A7A = const Color(0xff7A7A7A);
  static Color colorF5F5F5 = const Color(0xffF5F5F5);
  static Color color626262 = const Color(0xff626262);
  static Color color484848 = const Color(0xff484848);
  static Color colorDDDDDD = const Color(0xffDDDDDD);
}

class Common {
  static RxBool isLoading = false.obs;
  static bool isFold = false;

  static String getFormattedMobileNumber(String value) {
    if (value.length <= 3) {
      return value;
    } else if (value.length <= 7) {
      return '${value.substring(0, 3)}-${value.substring(3)}';
    } else if (value.length < 11) {
      return '${value.substring(0, 3)}-${value.substring(3, 6)}-${value.substring(6)}';
    } else {
      return '${value.substring(0, 3)}-${value.substring(3, 7)}-${value.substring(7, 11)}';
    }
  }

  static formattedSubway(List list) {
    return list.join('/');
  }

  static  bool isToday(DateTime date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(date) == formatter.format(DateTime.now());
  }


  static  bool isPreviousDate(DateTime date) {
    return date.isBefore(DateTime.now().subtract(const Duration(days: 1)));
  }


  static increaseMonth(Rx<DateTime> date) {
    return DateTime(date.value.year, date.value.month + 1);
  }

  static decreaseMonth(Rx<DateTime> date) {
    return DateTime(date.value.year, date.value.month - 1);
  }

  static String getFormattedNumber(String number) {
    return NumberFormat('#,###.##')
        .format(double.parse(number.replaceAll(",", "")));
  }

  static GetSnackBar getSnackBar(String message) {
    return GetSnackBar(
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 3),
      margin: EdgeInsets.all(14.r),
      borderRadius: 30.r,
      backgroundColor: Colors.black.withOpacity(0.8),
      messageText: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 12.w),
            child: SvgPicture.asset('assets/icon/notification_fail.svg'),
          ),
          Padding(
            padding: EdgeInsets.only(left: 10.w),
            child: Container(
              width: 270.w,
              height: 50.sp,
              alignment: Alignment.centerLeft,
              child: Text(
                message,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.sp,
                  fontVariations: CommonStyle.fontWeight700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CommonStyle {
  static TextStyle titleTextStyle = TextStyle(
    fontSize: 20.sp,
    fontVariations: fontWeight800,
  );

  static const fontWeight200 = [
    FontVariation('wght', 200),
  ];
  static const fontWeight400 = [
    FontVariation('wght', 400),
  ];

  static const fontWeight500 = [
    FontVariation('wght', 500),
  ];
  static const fontWeight600 = [
    FontVariation('wght', 600),
  ];

  static const fontWeight700 = [
    FontVariation('wght', 700),
  ];

  static const fontWeight800 = [
    FontVariation('wght', 800),
  ];
}
