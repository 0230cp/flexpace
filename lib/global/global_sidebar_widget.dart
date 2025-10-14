import 'package:firebase_auth/firebase_auth.dart';
import 'package:flexpace/common/common.dart';
import 'package:flexpace/common/service/userdata_service.dart';
import 'package:flexpace/global/global_bottom_notification_widget.dart';
import 'package:flexpace/global/global_image_widget.dart';
import 'package:flexpace/pages/terms/controller/terms_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class GlobalSidebarWidget extends StatelessWidget {
  GlobalSidebarWidget({super.key});

  final List<String> image = [
    'assets/sidebar/event.svg',
    'assets/sidebar/reservation.svg',
    'assets/sidebar/reviews.svg',
    'assets/sidebar/steamed.svg'
  ];

  final List<String> imageTitle = ['이벤트', '예약 리스트', '이용후기 Q&A관리', '찜한 공간'];

  final List<String> inventoryList = ['홈', '공지사항', '1:1 문의'];

  final List<String> routeList = [
    '/reserve',
    '/reserve',
    '/reserve',
    '/reserve'
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 300.w,
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(color: CommonColor.colorF5F5F5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 120.h,
              decoration: BoxDecoration(color: CommonColor.color1770C2),
              padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
              child: InkWell(
                onTap: () {
                  if (UserDataService.to.userData.value.docId != null) {
                    Get.toNamed('/profile');
                  } else {
                    Get.toNamed('/sign_in');
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(100.r),
                        child: Obx(() => GlobalImageWidget(
                              "${UserDataService.to.userData.value.profileImage?['url']}",
                              fit: BoxFit.cover,
                              width: 50.r,
                              height: 50.r,
                            ))),
                    Padding(
                      padding: EdgeInsets.only(left: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            UserDataService.to.userData.value.docId != null
                                ? UserDataService.to.userData.value.nickName
                                    .toString()
                                : "게스트로",
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontVariations: CommonStyle.fontWeight500,
                                color: Colors.white),
                          ),
                          Text(
                            UserDataService.to.userData.value.docId != null
                                ? '프로필 관리 >'
                                : '로그인/회원가입',
                            style: TextStyle(
                                fontSize: 16.sp,
                                fontVariations: CommonStyle.fontWeight800,
                                color: Colors.white),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                      image.length,
                      (index) => GestureDetector(
                            onTap: () {
                              if (index == 1) {
                                Get.close(0);
                                if (UserDataService.to.userData.value.docId !=
                                    null) {
                                  Get.toNamed(routeList[index]);
                                } else {
                                  Get.toNamed('/sign_in');
                                }
                              } else {
                                Get.bottomSheet(GlobalBottomNotificationWidget(
                                  tap: () {
                                    Get.close(0);
                                  },
                                ));
                              }
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(image[index]),
                                Text(
                                  imageTitle[index],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      fontVariations: CommonStyle.fontWeight700,
                                      color: CommonColor.color070707),
                                )
                              ],
                            ),
                          ))),
            ),
            Container(
              height: 12.h,
              decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(
                          width: 1.w, color: const Color(0xffDDDDDD)))),
            ),
            ...List.generate(
                inventoryList.length,
                (index) => InkWell(
                      onTap: () {
                        if (index == 0) {
                          Get.offAllNamed('/main');
                        } else if (index == 1) {
                          Get.offAllNamed('/notice');
                        } else if (index == 2) {
                          Get.bottomSheet(GlobalBottomNotificationWidget(
                            tap: () {
                              Get.close(0);
                            },
                          ));
                        }
                      },
                      child: Container(
                        height: 52.h,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.w,
                                    color: const Color(0xffDDDDDD)))),
                        padding: EdgeInsets.only(left: 24.w, right: 12.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              inventoryList[index],
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontVariations: CommonStyle.fontWeight600,
                              ),
                            ),
                            SvgPicture.asset('assets/icon/right_arrow.svg')
                          ],
                        ),
                      ),
                    )),
            Padding(
              padding: EdgeInsets.only(top: 28.h),
              child: InkWell(
                onTap: () async {
                  if (UserDataService.to.userData.value.docId != null) {
                    await signOut();
                  }
                  Get.offAllNamed('/sign_in');
                },
                child: Center(
                  child: Text(
                    UserDataService.to.userData.value.docId != null
                        ? '로그아웃'
                        : '로그인',
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontVariations: CommonStyle.fontWeight500,
                        color: CommonColor.color7A7A7A),
                  ),
                ),
              ),
            ),
            const Spacer(),
            smallText(text: '영업소재지 : 서울특별시 동작구 현충로 지하220, 지하2층 청년창업스튜디오 A-07'),
            smallText(text: '이메일 : contact@jinpia.site'),
            smallText(text: '대표전화 : +82) 10-2911-9815'),
            Container(
                width: 140.w,
                height: 24.58.h,
                margin: EdgeInsets.only(left: 32.w, top: 24.h, bottom: 24.h),
                child: SvgPicture.asset(
                  'assets/icon/logo.svg',
                  fit: BoxFit.fill,
                )),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 1.3.h,
              margin: EdgeInsets.symmetric(horizontal: 32.w),
              decoration: const BoxDecoration(color: Color(0xffD9D9D9)),
            ),
            Padding(
              padding: EdgeInsets.only(top: 24.h, bottom: 32.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () async {
                      Get.close(0);
                      if (Get.currentRoute == '/terms') {
                        TermsController.to.isTerms.value = true;
                        await Future.delayed(const Duration(milliseconds: 250));

                        TermsController.to.scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Get.toNamed('/terms', arguments: true);
                      }
                    },
                    child: Text(
                      '이용약관',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontVariations: CommonStyle.fontWeight700,
                          color: CommonColor.color7A7A7A),
                    ),
                  ),
                  Container(
                    width: 2.w,
                    height: 8.h,
                    margin: EdgeInsets.symmetric(horizontal: 8.w),
                    decoration: BoxDecoration(color: CommonColor.color7A7A7A),
                  ),
                  InkWell(
                    onTap: () async {
                                            Get.close(0);

                      if (Get.currentRoute == '/terms') {
                        TermsController.to.isTerms.value = false;
                        await Future.delayed(const Duration(milliseconds: 250));

                        TermsController.to.scrollController.animateTo(
                          0,
                          duration: Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        Get.toNamed('/terms', arguments: false);
                      }
                    },
                    child: Text(
                      '개인정보처리방침',
                      style: TextStyle(
                          fontSize: 14.sp,
                          fontVariations: CommonStyle.fontWeight700,
                          color: CommonColor.color7A7A7A),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

Future<void> signOut() async {
  try {
    await FirebaseAuth.instance.signOut();

    UserDataService.to.userData.value = UserModel();

    Get.offAllNamed('/sign_in'); // 모든 페이지 스택을 제거하고 로그인 페이지로

    Get.showSnackbar(Common.getSnackBar('로그아웃되었습니다'));
  } catch (e) {
    print('로그아웃 중 에러 발생: $e');
    Get.showSnackbar(Common.getSnackBar('로그아웃 중 문제가 발생했습니다. 다시 시도해주세요.'));
  }
}

Widget smallText({required String text}) {
  return Padding(
    padding: EdgeInsets.only(top: 4.h, left: 32.w, right: 32.w),
    child: Text(
      text,
      style: TextStyle(
          fontSize: 10.sp,
          fontVariations: CommonStyle.fontWeight400,
          color: CommonColor.color7A7A7A),
    ),
  );
}
