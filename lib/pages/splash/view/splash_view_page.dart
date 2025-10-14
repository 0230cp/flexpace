import 'package:flexpace/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../global/global_layout_widget.dart';
import '../controller/splash_controller.dart';

class SplashViewPage extends GetView<SplashController> {
  const SplashViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(() => Text(controller.version.value)),
            Padding(
              padding: EdgeInsets.only(left: 32.w, bottom: 32.h),
              child: Stack(
                children: [
                  textWidget(blueText: '공', blackText: '간을'),
                  Padding(
                    padding: EdgeInsets.only(top: 62.h, left: 35.w),
                    child: textWidget(blueText: '유', blackText: '연하게'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 26.5.w, bottom: 72.h),
              child: Image.asset('assets/splash/splash.png'),
            ),
            SvgPicture.asset('assets/splash/logo.svg'),
            SizedBox(
              height: 42.h,
            )
          ],
        ));
  }
}

Widget textWidget({
  required String blueText,
  required String blackText,
}) {
  return Row(
    children: [
      Text(
        blueText,
        style: TextStyle(
            fontSize: 58.sp,
            fontVariations: CommonStyle.fontWeight800,
            color: CommonColor.color1770C2),
      ),
      Text(
        blackText,
        style: TextStyle(
            fontSize: 58.sp,
            fontVariations: CommonStyle.fontWeight200,
            color: CommonColor.color070707),
      )
    ],
  );
}
