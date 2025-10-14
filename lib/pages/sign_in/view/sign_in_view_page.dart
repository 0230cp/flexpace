import 'dart:io';

import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/pages/sign_in/controller/sign_in_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../global/global_layout_widget.dart';

class SignInViewPage extends GetView<SignInController> {
  const SignInViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        backgroundColor: const Color(0xffF6F6F6),
        context: context,
        appBar: const GlobalAppbarWidget(),
        drawer: GlobalSidebarWidget(),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: 24.h),
                child: InkWell(
                  onTap: () {
                    Get.toNamed('/main');
                  },
                  child: Text(
                    '게스트 로그인',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontVariations: CommonStyle.fontWeight800,
                    ),
                  ),
                ),
              ),
              ...List.generate(
                  controller.social.length,
                  (index) => Platform.isIOS || index != 2
                      ? Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: InkWell(
                              onTap: () {
                                controller.login(index);
                              },
                              child:
                                  SvgPicture.asset(controller.social[index])),
                        )
                      : SizedBox())
            ],
          ),
        ));
  }
}
