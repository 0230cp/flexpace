import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class GlobalBottomNotificationWidget extends StatelessWidget {
  const GlobalBottomNotificationWidget({
    super.key,
    this.isRequest = false,
    required this.tap,
  });

  final bool isRequest;
  final Function tap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(12), topLeft: Radius.circular(12))),
      padding: EdgeInsets.symmetric(vertical: 32.h, horizontal: 24.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            isRequest ? '예약 신청이 완료되었습니다' : '준비 중인 서비스입니다',
            style: TextStyle(
                fontSize: 20.sp,
                fontVariations: CommonStyle.fontWeight800,
                color: CommonColor.color070707),
          ),
          isRequest
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '프로필에 등록된 전화번호로 ',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontVariations: CommonStyle.fontWeight500,
                              color: const Color(0xff7E7E7E)),
                        ),
                        TextSpan(
                          text: '[결제 안내 및 예약 확정]',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontVariations: CommonStyle.fontWeight800,
                              color: const Color(0xff7E7E7E)),
                        ),
                        TextSpan(
                          text: '을 위해 연락드릴 예정입니다.',
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontVariations: CommonStyle.fontWeight500,
                              color: const Color(0xff7E7E7E)),
                        ),
                      ],
                    ),
                  ),
                )
              : Padding(
                  padding: EdgeInsets.symmetric(vertical: 24.h),
                  child: Text(
                    '새로운 서비스가 곧 출시됩니다. 기대해 주세요!',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontVariations: CommonStyle.fontWeight500,
                        color: CommonColor.color070707),
                  ),
                ),
          InkWell(
            onTap: () {
              tap();
            },
            child: GlobalButtonWidget(
                text: '확인',
                textColor: CommonColor.color070707,
                boxColor: CommonColor.colorF0E68C),
          )
        ],
      ),
    );
  }
}
