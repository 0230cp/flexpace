import 'package:flexpace/common/common.dart';
import 'package:flexpace/pages/terms/controller/terms_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class GlobalBusinessInfoWidget extends StatelessWidget {
  const GlobalBusinessInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(color: Color(0xffE7E7E7)),
      margin: EdgeInsets.only(top: 22.h),
      padding:
          EdgeInsets.only(top: 42.h, bottom: 30.h, left: 32.w, right: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: bigText(text: '진피아 (Jinpia) 사업자 정보'),
          ),
          smallText(text: '상호명 : 진피아(Jinpia)'),
          smallText(text: '대표 : 고재찬'),
          smallText(text: '사업자등록번호 : 428-13-02680'),
          smallText(text: '영업소재지 : 서울특별시 동작구 현충로 지하220, 지하2층 청년창업스튜디오 A-07'),
          smallText(text: '이메일 : contact@jinpia.site'),
          smallText(text: '대표전화 : +82) 10-2911-9815'),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 24.h),
            child: SvgPicture.asset('assets/icon/logo.svg'),
          ),
          Container(
            width: MediaQuery.sizeOf(context).width,
            height: 1.3.h,
            margin: EdgeInsets.only(bottom: 24.h),
            decoration: const BoxDecoration(color: Color(0xffD9D9D9)),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () async {
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
                  child: bigText(text: '이용약관')),
              Container(
                width: 2.w,
                height: 8.h,
                margin: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(color: CommonColor.color7A7A7A),
              ),
              InkWell(
                  onTap: () async {
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
                  child: bigText(text: '개인정보처리방침'))
            ],
          )
        ],
      ),
    );
  }
}

Widget smallText({required String text}) {
  return Padding(
    padding: EdgeInsets.only(top: 4.h),
    child: Text(
      text,
      style: TextStyle(
          fontSize: 10.sp,
          fontVariations: CommonStyle.fontWeight400,
          color: CommonColor.color7A7A7A),
    ),
  );
}

Widget bigText({required String text}) {
  return Text(
    text,
    style: TextStyle(
        fontSize: 14.sp,
        fontVariations: CommonStyle.fontWeight700,
        color: CommonColor.color7A7A7A),
  );
}
