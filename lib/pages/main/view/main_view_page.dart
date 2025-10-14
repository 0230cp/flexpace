import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_business_info_widget.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/pages/main/controller/main_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import '../../../global/global_layout_widget.dart';

class MainViewPage extends GetView<MainController> {
  const MainViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        drawer: GlobalSidebarWidget(),
        appBar: const GlobalAppbarWidget(),
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 42.h, left: 20.w, bottom: 23.h),
                child: Text(
                  '어떤 공간이 필요하신가요?',
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontVariations: CommonStyle.fontWeight800,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 35.w),
                child: GridView.builder(
                  primary: false,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 23.h,
                    crossAxisSpacing: 23.w,
                    childAspectRatio: 0.79,
                  ),
                  itemCount: controller.mainImage.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Get.toNamed('/space_list',
                            arguments: controller.mainText[index]);
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 150.w,
                            height: 150.w,
                            margin: EdgeInsets.only(bottom: 16.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(36),
                                color: CommonColor.colorF5F5F5),
                            child: Center(
                                child: SvgPicture.asset(
                                    controller.mainImage[index])),
                          ),
                          Text(
                            controller.mainText[index],
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontVariations: CommonStyle.fontWeight600,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
              const GlobalBusinessInfoWidget()
            ],
          ),
        ));
  }
}
