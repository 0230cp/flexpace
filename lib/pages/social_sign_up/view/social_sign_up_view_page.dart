import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_button_widget.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/global/global_text_field_widget.dart';
import 'package:flexpace/pages/social_sign_up/controller/social_sign_up_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../global/global_layout_widget.dart';

class SocialSignUpViewPage extends GetView<SocialSignUpController> {
  const SocialSignUpViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        backgroundColor: const Color(0xffF6F6F6),
        context: context,
        appBar: const GlobalAppbarWidget(),
        drawer: GlobalSidebarWidget(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 42.h, bottom: 24.h),
                child: Center(
                  child: Text(
                    '회원가입',
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(controller.logo[controller.key]!),
                          SizedBox(
                            width: 8.w,
                          ),
                          Text(
                            '${controller.key}로 회원가입',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontVariations: CommonStyle.fontWeight800,
                            ),
                          )
                        ],
                      ),
                    ),
                    GlobalTextField(
                      hintText: '이름(실명)',
                      textEditingController: controller.nameController,
                      onChanged: (value) {
                        controller.validateName();
                      },
                      isExist: false,
                    ),
                    Obx(() => controller.isErrorName.value
                        ? Padding(
                          padding:  EdgeInsets.only(top: 5.h),
                          child: Text(
                              controller.errorTextName.value,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: const Color(0xffFF6A74),
                                fontVariations: CommonStyle.fontWeight500,
                              ),
                            ),
                        )
                        : SizedBox()),
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
                      padding:  EdgeInsets.only(top: 5.h),
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

                    SizedBox(
                      height: 12.h,
                    ),
                    GlobalTextField(
                      hintText: '이메일',
                      textEditingController: controller.emailController,
                      onChanged: (value) {
                        controller.validateEmail();
                      },
                      isExist: false,
                      isReadOnly: controller.email.isNotEmpty,
                    ),

                    Obx(() => controller.isErrorEmail.value
                        ? Padding(
                      padding:  EdgeInsets.only(top: 5.h),
                          child: Text(
                                                controller.errorTextEmail.value,
                                                style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xffFF6A74),
                          fontVariations: CommonStyle.fontWeight500,
                                                ),
                                              ),
                        )
                        : SizedBox()),


                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 1.h,
                      margin: EdgeInsets.symmetric(vertical: 20.h),
                      decoration: BoxDecoration(color: CommonColor.colorDFDFDF),
                    ),
                    Obx(
                      () => GlobalTextField(
                        hintText: '휴대폰 번호',
                        textEditingController: controller.phoneNumberController,
                        onChanged: (value) {
                          controller.validateMobileNumber(value);
                        },
                        isExist: false,
                        isReadOnly: controller.isCheckNumber.value,
                        suffix: GestureDetector(
                          onTap: () {
                            controller.sendAuthNumberTap();
                          },
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 16.w),
                            child: Text(
                              '인증번호 전송',
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  fontVariations: CommonStyle.fontWeight700,
                                  color: CommonColor.color070707),
                            ),
                          ),
                        ),
                      ),
                    ),

                    Obx(() => controller.isErrorMobileNumber.value
                        ? Padding(
                      padding:  EdgeInsets.only(top: 5.h),
                          child: Text(
                                                controller.errorTextMobileNumber.value,
                                                style: TextStyle(
                          fontSize: 12.sp,
                          color: const Color(0xffFF6A74),
                          fontVariations: CommonStyle.fontWeight500,
                                                ),
                                              ),
                        )
                        : SizedBox()),

                    SizedBox(
                      height: 12.h,
                    ),
                    Obx(
                      () => controller.isCondSend.value
                          ? GlobalTextField(
                              hintText: '인증번호',
                              textEditingController:
                                  controller.checkNumberController,
                              onChanged: (value) {
                                controller.emptyCheck();
                              },
                              isExist: false,
                              isReadOnly: controller.isCheckNumber.value,
                              suffix: Padding(
                                padding: EdgeInsets.symmetric(
                                    vertical: 16.h, horizontal: 16.w),
                                child: Obx(
                                  () => Text(
                                    controller.timerTextMobileNumber.value,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontVariations:
                                            CommonStyle.fontWeight500,
                                        color: const Color(0xff828282)),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox(),
                    ),
                    SizedBox(
                      height: 12.h,
                    ),
                    Obx(
                      () => controller.isCondSend.value
                          ? InkWell(
                              onTap: () {
                                controller.checkNumber();
                              },
                              child: GlobalButtonWidget(
                                  text: '인증하기',
                                  textColor:
                                      controller.isNotEmptyCheckNumber.value &&
                                              !controller.isCheckNumber.value
                                          ? Colors.white
                                          : CommonColor.colorBFBFBF,
                                  boxColor:
                                      controller.isNotEmptyCheckNumber.value &&
                                              !controller.isCheckNumber.value
                                          ? CommonColor.color484848
                                          : CommonColor.colorF5F5F5),
                            )
                          : const SizedBox(),
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 1.h,
                      margin: EdgeInsets.symmetric(vertical: 20.h),
                      decoration: BoxDecoration(color: CommonColor.colorDFDFDF),
                    ),
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(bottom: 12.h),
                          child: InkWell(
                            onTap: () {
                              controller.checkAll();
                            },
                            child: Row(
                              children: [
                                Obx(
                                  () => SvgPicture.asset(
                                    'assets/icon/big_check.svg',
                                    colorFilter: ColorFilter.mode(
                                        controller.allAgree.value
                                            ? CommonColor.color070707
                                            : const Color(0xff838383),
                                        BlendMode.srcIn),
                                  ),
                                ),
                                SizedBox(
                                  width: 6.w,
                                ),
                                Obx(
                                  () => Text(
                                    '아래 약관에 모두 동의합니다.',
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontVariations:
                                            CommonStyle.fontWeight700,
                                        color: controller.allAgree.value
                                            ? CommonColor.color070707
                                            : const Color(0xff838383)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        ...List.generate(controller.termsConditions.length,
                            (index) {
                          return Obx(() {
                            Color colors = controller.agreeList[index].value
                                ? const Color(0xff626262)
                                : const Color(0xffB0B0B0);
                            return InkWell(
                              onTap: () {
                                controller.checkOne(index);
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                  bottom: 11.h,
                                  left: 24.w,
                                ),
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/icon/check.svg',
                                      colorFilter: ColorFilter.mode(
                                          colors, BlendMode.srcIn),
                                    ),
                                    SizedBox(
                                      width: 6.w,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          bottom: BorderSide(
                                            width: 1.w,
                                            color: index == 0 || index == 1
                                                ? const Color(0xffB0B0B0)
                                                : Colors.transparent,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        controller.termsConditions[index],
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          fontVariations:
                                              CommonStyle.fontWeight500,
                                          color: colors,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                        }),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 13.h, bottom: 24.h),
                      child: InkWell(
                        onTap: (){
                          controller.registerUser();
                        },
                        child: GlobalButtonWidget(
                            text: '회원가입',
                            textColor: const Color(0xff070707),
                            boxColor: CommonColor.colorF0E68C),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
