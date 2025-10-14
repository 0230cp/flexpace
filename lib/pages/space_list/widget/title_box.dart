import 'package:flexpace/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

class TitleBox extends StatelessWidget {
  final String title;

  const TitleBox({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              bottom: BorderSide(width: 1.w, color: CommonColor.colorDDDDDD))),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 24.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            Text(
              title,
              style: TextStyle(
                  fontSize: 16.sp,
                  fontVariations: CommonStyle.fontWeight600,
                  color: CommonColor.color070707),
            ),
            InkWell(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset('assets/icon/close.svg'),
            )
          ],
        ),
      ),
    );
  }
}
