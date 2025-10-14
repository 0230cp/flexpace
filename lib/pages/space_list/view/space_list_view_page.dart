import 'package:cached_network_image/cached_network_image.dart';
import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/pages/space_list/controller/space_list_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../global/global_layout_widget.dart';

class SpaceListViewPage extends GetView<SpaceListController> {
  const SpaceListViewPage({super.key});

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
                padding: EdgeInsets.only(top: 42.h, left: 20.w),
                child: Text(
                  controller.type,
                  style: CommonStyle.titleTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
                child: Row(
                  children: List.generate(
                      controller.menu.length,
                      (index) => GestureDetector(
                            onTap: () {
                              controller.selectedMenu.value =
                                  controller.menu[index];
                              controller.selectedMenuDialog(
                                  controller.selectedMenu.value);
                            },
                            child: Obx(
                              () => Container(
                                margin: EdgeInsets.only(right: 10.w),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                        width: 1.r,
                                        color: controller.selectedMenu.value ==
                                                controller.menu[index]
                                            ? CommonColor.color1770C2
                                            : CommonColor.colorBFBFBF)),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16.w, vertical: 8.h),
                                child: Text(
                                  controller.menu[index],
                                  style: TextStyle(
                                      fontSize: 14.sp,
                                      fontVariations: CommonStyle.fontWeight500,
                                      color: controller.selectedMenu.value ==
                                              controller.menu[index]
                                          ? CommonColor.color1770C2
                                          : CommonColor.color626262),
                                ),
                              ),
                            ),
                          )),
                ),
              ),
              Obx(
                () => ListView.builder(
                    primary: false,
                    shrinkWrap: true,
                    itemCount: controller.spaceList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: InkWell(
                          onTap: () {
                            Get.toNamed('/space_detail',
                                arguments: controller.spaceList[index]);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    bottom: BorderSide(
                                        width: 1.w,
                                        color: const Color(0xffDDDDDD)))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      '${controller.spaceList[index]['image']['url']}',
                                  width: MediaQuery.sizeOf(context).width,
                                  height: 200.h,
                                  fit: BoxFit.fill,
                                ),
                                Container(
                                  constraints: BoxConstraints(maxWidth: 250.w),
                                  margin: EdgeInsets.only(
                                      top: 20.h, left: 24.w, right: 24.w),
                                  child: Text(
                                    controller.spaceList[index]['title'],
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontVariations:
                                            CommonStyle.fontWeight800),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 8.5.h, horizontal: 24.w),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icon/location.svg'),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.w),
                                        child: Text(
                                          Common.formattedSubway(controller
                                              .spaceList[index]['subway']),
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: CommonColor.color626262,
                                              fontVariations:
                                                  CommonStyle.fontWeight800),
                                        ),
                                      ),
                                      Container(
                                        width: 2.w,
                                        height: 8.h,
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 8.w),
                                        decoration: BoxDecoration(
                                            color: CommonColor.colorBFBFBF),
                                      ),
                                      SvgPicture.asset(
                                          'assets/icon/people.svg'),
                                      Padding(
                                        padding: EdgeInsets.only(left: 2.w),
                                        child: Text(
                                          '최대 ${controller.spaceList[index]['maximum']}인',
                                          style: TextStyle(
                                              fontSize: 12.sp,
                                              color: CommonColor.color626262,
                                              fontVariations:
                                                  CommonStyle.fontWeight800),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: 24.w, bottom: 12.h),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 4.w),
                                        child: Text(
                                          Common.getFormattedNumber(
                                              '${controller.spaceList[index]['defaultPrice']}'),
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              color: CommonColor.color1770C2,
                                              fontVariations:
                                                  CommonStyle.fontWeight800),
                                        ),
                                      ),
                                      Text(
                                        '원/시간',
                                        style: TextStyle(
                                            fontSize: 12.sp,
                                            color: CommonColor.color626262,
                                            fontVariations:
                                                CommonStyle.fontWeight600),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ));
  }
}
