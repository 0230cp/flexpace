import 'package:flexpace/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class BottomNavigationBox extends StatelessWidget {
  final Function call;
  final Function reserve;

  const BottomNavigationBox(
      {super.key, required this.call, required this.reserve});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 54.h,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            offset: const Offset(0, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              call();
            },
            child: SizedBox(
              width: 150.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset('assets/icon/phone.svg'),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    '전화',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontVariations: CommonStyle.fontWeight800,
                        color: const Color(0xff070707)),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                reserve();
              },
              child: Container(
                decoration: BoxDecoration(color: CommonColor.color1770C2),
                child: Center(
                  child: Text(
                    '예약하기',
                    style: TextStyle(
                        fontSize: 16.sp,
                        fontVariations: CommonStyle.fontWeight800,
                        color: Colors.white),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
