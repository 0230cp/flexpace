import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_business_info_widget.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/pages/notice_detail/controller/notice_detail_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../global/global_layout_widget.dart';

class NoticeDetailViewPage extends GetView<NoticeDetailController> {
  const NoticeDetailViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        appBar: const GlobalAppbarWidget(),
        drawer: GlobalSidebarWidget(),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          controller.data['title'],
                          style: TextStyle(
                            fontSize: 20.sp,
                            fontVariations: CommonStyle.fontWeight800,
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(8),
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 10.w),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                    width: 1.r,
                                    color: CommonColor.colorBFBFBF)),
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 8.h),
                            child: Text(
                              "목록으로",
                              style: TextStyle(
                                  fontSize: 14.sp,
                                  fontVariations: CommonStyle.fontWeight500,
                                  color: CommonColor.color070707),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "작성일 ${DateFormat('yyyy.MM.dd').format(controller.data['createAt'].toDate())}",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: CommonColor.color626262,
                      fontVariations: CommonStyle.fontWeight600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.h),
                    child: Container(
                        height: 1.h,
                        width: MediaQuery.sizeOf(context).width,
                        color: const Color(0xffDDDDDD)),
                  ),
                  Text(
                    controller.data['contents'],
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: CommonColor.color070707,
                      fontVariations: CommonStyle.fontWeight500,
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            const GlobalBusinessInfoWidget(),
          ],
        ));
  }
}
