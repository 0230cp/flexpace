import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexpace/common/common.dart';
import 'package:flexpace/common/service/userdata_service.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_business_info_widget.dart';
import 'package:flexpace/global/global_confirm_widget.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/pages/profile/controller/profile_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../global/global_image_widget.dart';
import '../../../global/global_layout_widget.dart';

class ProfileViewPage extends GetView<ProfileController> {
  const ProfileViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        backgroundColor: CommonColor.colorF5F5F5,
        appBar: const GlobalAppbarWidget(),
        drawer: GlobalSidebarWidget(),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: UserDataService.to.userData.value.docId == null
          ? Text(
            controller.dummy.value,
            style: CommonStyle.titleTextStyle,
          )
          : Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 42.h, bottom: 23.h),
                child: Text(
                  '프로필 관리',
                  style: CommonStyle.titleTextStyle,
                ),
              ),
              ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child: Obx(()=> GlobalImageWidget("${UserDataService.to.userData.value.profileImage?['url']}",fit: BoxFit.cover,width: 100.r,height: 100.r,))),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h),
                child: Obx(() =>   Text(
                  UserDataService.to.userData.value.nickName ?? '정보없음',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontVariations: CommonStyle.fontWeight600,
                  ),
                ),),
              ),
              InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: (){
                  controller.updateProfile();
                },
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(width: 1.r, color: const Color(0xffDDDDDD)),
                      color: Colors.white),
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: Text(
                    '프로필 사진 변경',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: CommonColor.color070707,
                      fontVariations: CommonStyle.fontWeight500,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                margin: EdgeInsets.only(top: 23.h, left: 23.5.w, right: 23.5.w),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 24.w),
                child: Column(
                  children: [
                    rowText(title: '이름', text: UserDataService.to.userData.value.name ?? '정보없음'),
                Obx(() =>     rowText(
                        title: '닉네임',
                        text: UserDataService.to.userData.value.nickName ?? '정보없음' ,
                        widget: InkWell(
                          onTap: (){
                            Get.toNamed('/change_nickname');
                          },
                          child: Container(
                            height: 20.h,
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.w,
                                        color: const Color(0xff626262)))),
                            child: Text(
                              '변경하기',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xff626262),
                                fontVariations: CommonStyle.fontWeight600,
                              ),
                            ),
                          ),
                        )),),
                    rowText(title: '이메일', text: UserDataService.to.userData.value.email ?? '정보없음' ),
                    rowText(title: '연락처', text: UserDataService.to.userData.value.phoneNumber ?? '정보없음' ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 30.w),
                          child: Text(
                            '마케팅 수신동의',
                            style: TextStyle(
                                fontSize: 14.sp,
                                fontVariations: CommonStyle.fontWeight600,
                                color: const Color(0xff626262)),
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  margin: EdgeInsets.only(right: 24.w),
                                  child: Text(
                                    '이메일',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontVariations: CommonStyle.fontWeight600,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.isEmail.value = !controller.isEmail.value;
                                    controller.updateMarketing();
                                  },
                                  child: Obx(() => SvgPicture.asset(
                                      controller.isEmail.value
                                          ? 'assets/icon/toggle_on.svg'
                                          : 'assets/icon/toggle_off.svg')),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Row(
                              children: [
                                Container(
                                  width: 40.w,
                                  margin: EdgeInsets.only(right: 24.w),
                                  child: Text(
                                    'SMS',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontVariations: CommonStyle.fontWeight600,
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    controller.isSMS.value = !controller.isSMS.value;
                                    controller.updateMarketing();
                                  },
                                  child: Obx(() => SvgPicture.asset(
                                      controller.isSMS.value
                                          ? 'assets/icon/toggle_on.svg'
                                          : 'assets/icon/toggle_off.svg')),
                                )
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                    Container(
                      width: MediaQuery.sizeOf(context).width,
                      height: 1.h,
                      margin: EdgeInsets.only(top: 40.h, bottom: 24.h),
                      decoration: const BoxDecoration(color: Color(0xffD9D9D9)),
                    ),
                    InkWell(
                      onTap:(){
                        Get.dialog(GlobalConfirmWidget(title: '서비스 탈퇴', content: '정말 서비스 탈퇴를 하시겠습니까?', onSubmit: () {
                         controller.deleteUser();  },));

                      },
                      child: Container(
                        height: 20.h,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.w, color: const Color(0xff626262)))),
                        child: Text(
                          '서비스 탈퇴하기',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xff626262),
                            fontVariations: CommonStyle.fontWeight600,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const GlobalBusinessInfoWidget()
            ],
          ),),
        );
  }
}

Widget rowText({required String title, required String text, Widget? widget}) {
  return Padding(
    padding: EdgeInsets.only(bottom: 24.h),
    child: Row(children: [
      Container(
        width: 40.w,
        margin: EdgeInsets.only(right: 42.w),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14.sp,
            color: const Color(0xff626262),
            fontVariations: CommonStyle.fontWeight600,
          ),
        ),
      ),
      Text(
        text,
        style: TextStyle(
          fontSize: 14.sp,
          fontVariations: CommonStyle.fontWeight600,
        ),
      ),
      const Spacer(),
      widget ?? const SizedBox()
    ]),
  );
}
