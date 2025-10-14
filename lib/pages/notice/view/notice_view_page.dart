import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_business_info_widget.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/pages/notice/controller/notice_controller.dart';
import 'package:flexpace/pages/sign_in/controller/sign_in_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../global/global_layout_widget.dart';

class NoticeViewPage extends GetView<NoticeController> {
  const NoticeViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        appBar: const GlobalAppbarWidget(),
        drawer: GlobalSidebarWidget(),
        body: SingleChildScrollView(
          controller: controller.noticeListScrollController,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(bottom: 24.h,top: 42.h),
                  child: Text(
                    '공지사항',
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontVariations: CommonStyle.fontWeight800,
                    ),
                  ),
                ),
          
                Container(
          height: 1.h,
          width: MediaQuery.sizeOf(context).width,
                 color: const Color(0xffDDDDDD)),
          
          
           Obx(() =>      ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: controller.noticeList.length,
                    itemBuilder: (context, index) {
                      return  InkWell(
                        onTap: (){
                          Get.toNamed('/notice_detail',arguments: controller.noticeList[index]);
                        },
                        child: Container(
                          width: MediaQuery.sizeOf(context).width,
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(
                                      width: 1.w, color: const Color(0xffDDDDDD)))),
                          child: Padding(
                            padding:  EdgeInsets.symmetric(horizontal: 24.w,vertical: 20.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  DateFormat('yyyy.MM.dd').format(controller.noticeList[index]['createAt'].toDate()),
                                  style: TextStyle(
                                    fontSize: 12.sp,
                                    color: CommonColor.color626262,
                                    fontVariations: CommonStyle.fontWeight600,
                                  ),
                                ),

                                Text(controller.noticeList[index]['title'],
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontVariations: CommonStyle.fontWeight800,
                                  ),
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    })),
          
          
                const GlobalBusinessInfoWidget(),
          
          
              ],
            ),
          ),
        ));
  }
}
