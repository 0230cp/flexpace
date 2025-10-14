import 'package:flexpace/common/common.dart';
import 'package:flexpace/common/send_sms.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_business_info_widget.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/pages/reseve/widget/reserve_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../global/global_layout_widget.dart';
import '../controller/reserve_controller.dart';

class ReserveViewPage extends GetView<ReserveController> {
  const ReserveViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        backgroundColor: CommonColor.colorF5F5F5,
        appBar: const GlobalAppbarWidget(),
        drawer: GlobalSidebarWidget(),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 42.h, bottom: 23.h),
              child: Text(
                '예약 내역 리스트',
                style: TextStyle(
                  fontSize: 20.sp,
                  fontVariations: const [
                    FontVariation('wght', 800), // 폰트 두께
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 41.h,
              color: CommonColor.color1770C2,
              child: Padding(
                padding: EdgeInsets.only(left: 20.w),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    '총 ${controller.reserveList.length}건',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontVariations: const [
                        FontVariation('wght', 500), // 폰트 두께
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 41.h,
              decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: Color(0xFFDDDDDD),
                      width: 1.0,
                    ),
                    bottom: BorderSide(
                      color: Color(0xFFDDDDDD),
                      width: 1.0,
                    ),
                  ),
                  color: Colors.white),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.toggleSortOrder();
                      },
                      child: SizedBox(
                        width: 65.w,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(right: 4.w),
                              child: Text(
                                '예약번호',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: CommonColor.color1770C2,
                                  fontVariations: const [
                                    FontVariation('wght', 500), // 폰트 두께
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 11.w,
                              child: Obx(
                                () => SvgPicture.asset(controller.isOldest.value
                                    ? 'assets/icon/down_arrow.svg'
                                    : 'assets/icon/up_arrow.svg'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 106.5.w,
                      child: Center(
                        child: Text(
                          '가격',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: CommonColor.color626262,
                            fontVariations: const [
                              FontVariation('wght', 500), // 폰트 두께
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 106.5.w,
                      child: Center(
                        child: Text(
                          '이용일자',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: CommonColor.color626262,
                            fontVariations: const [
                              FontVariation('wght', 500), // 폰트 두께
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.w,
                      child: Center(
                        child: Text(
                          '상태',
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: CommonColor.color626262,
                            fontVariations: const [
                              FontVariation('wght', 500), // 폰트 두께
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Obx(() => ReservationListWidget(
                    reserveList: controller.reserveList.value,
                    onTap: (int index) {
                      //todo 라우팅 로직 넣기
                      controller.getDetail(index);
                    },
                    isReverse: controller.isOldest.value,
                    scrollController: controller.reserveListScrollController,
                  )),
            ),
            const GlobalBusinessInfoWidget(),
          ],
        ));
  }
}
