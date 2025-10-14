import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_business_info_widget.dart';
import 'package:flexpace/global/global_button_widget.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/global/global_text_field_widget.dart';
import 'package:flexpace/pages/change_nickname/controller/notice_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../global/global_layout_widget.dart';

class ChangeNickNameViewPage extends GetView<ChangeNickNameController> {
  const ChangeNickNameViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        appBar: const GlobalAppbarWidget(),
        drawer: GlobalSidebarWidget(),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 42.h, bottom: 24.h),
                child: Center(
                  child: Text(
                    '닉네임 변경',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontVariations: CommonStyle.fontWeight800,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                decoration: const BoxDecoration(color: Colors.white),
                padding: EdgeInsets.symmetric(
                  horizontal: 20.w,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: 26.h, top: 24.h),
                      child: Text(
                        '변경할 닉네임을 입력해주세요',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontVariations: CommonStyle.fontWeight800,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    GlobalTextField(
                      hintText: '닉네임',
                      textEditingController: controller.nicknameController,
                      onChanged: (value) {
                        controller.validateNickName();
                      },
                      isExist: false,
                    ),
                    Obx(() => controller.isErrorNickName.value
                        ? Padding(
                            padding: EdgeInsets.only(top: 5.h),
                            child: Text(
                              controller.errorTextNickName.value,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xffFF6A74),
                                fontVariations: CommonStyle.fontWeight500,
                              ),
                            ),
                          )
                        : SizedBox()),
                    Padding(
                      padding: EdgeInsets.only(top: 13.h, bottom: 24.h),
                      child: InkWell(
                        onTap: () async {
                   await       controller.updateNickName();
                        },
                        child: GlobalButtonWidget(
                            text: '변경하기',
                            textColor: const Color(0xff070707),
                            boxColor: CommonColor.colorF0E68C),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              const GlobalBusinessInfoWidget(),
            ],
          ),
        ));
  }
}
