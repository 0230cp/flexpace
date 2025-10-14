import 'package:flexpace/common/common.dart';
import 'package:flexpace/common/service/userdata_service.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_business_info_widget.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/pages/space_detail/controller/space_detail_controller.dart';
import 'package:flexpace/pages/space_detail/widget/bottom_navigation_box.dart';
import 'package:flexpace/pages/space_detail/widget/image_carousel.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../global/global_layout_widget.dart';

class SpaceDetailViewPage extends GetView<SpaceDetailController> {
  const SpaceDetailViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        drawer: GlobalSidebarWidget(),
        appBar: const GlobalAppbarWidget(),
        bottomNavigationBar: BottomNavigationBox(call: () {
          controller.contact(controller.spaceDetail['phoneNumber']);
        }, reserve: () {
          if (UserDataService.to.userData.value.docId != null) {
            Get.toNamed('/reservation', arguments: controller.spaceDetail);
          } else {
            Get.toNamed('/sign_in');
          }
        }),
        body: SingleChildScrollView(
            controller: ScrollController(),
            physics: const ClampingScrollPhysics(),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Obx(
                () => ImageCarousel(
                  list: controller.spaceDetail['detailImage'],
                  slider: controller.carouselSliderIndex.value,
                  carouselController: controller.carouselController,
                  onPageChanged: (index, reason) {
                    controller.carouselSliderIndex.value = index;
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(
                    left: 24.w, right: 24.w, top: 20.h, bottom: 12.h),
                decoration: BoxDecoration(
                  color: CommonColor.colorF0E68C,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                child: Text(
                  '최대 수용 인원 ${controller.spaceDetail['maximum']}명',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontVariations: CommonStyle.fontWeight800,
                    color: CommonColor.color1770C2,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  controller.spaceDetail['title'],
                  style: CommonStyle.titleTextStyle,
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: 24.w, right: 24.w, top: 8.h, bottom: 24.h),
                child: Text(
                  '[${Common.formattedSubway(controller.spaceDetail['subway'])}] ${controller.spaceDetail['subTitle']}',
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontVariations: CommonStyle.fontWeight700,
                      color: CommonColor.color626262),
                ),
              ),
              Container(
                width: MediaQuery.sizeOf(context).width,
                height: 1.h,
                margin: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 28.h),
                decoration: const BoxDecoration(color: Color(0xffD9D9D9)),
              ),
              underscoreText('공간 소개'),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Text(
                  controller.spaceDetail['introduction'],
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontVariations: CommonStyle.fontWeight600,
                      color: CommonColor.color626262),
                ),
              ),
              SizedBox(
                height: 78.h,
              ),
              underscoreText('시설 안내'),
              textList(controller.spaceDetail['guide']),
              SizedBox(
                height: 62.h,
              ),
              underscoreText('예약시 주의사항'),
              textList(controller.spaceDetail['caution']),
              SizedBox(
                height: 62.h,
              ),
              underscoreText('공간 위치'),
              Padding(
                padding: EdgeInsets.only(left: 24.w, right: 24.w, bottom: 16.h),
                child: Row(
                  children: [
                    SizedBox(
                        width: 24.h,
                        height: 24.h,
                        child: SvgPicture.asset(
                          'assets/icon/location.svg',
                          fit: BoxFit.fill,
                        )),
                    SizedBox(
                      width: 8.w,
                    ),
                    Text(
                      controller.spaceDetail['location']['location'],
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontVariations: CommonStyle.fontWeight500,
                          color: CommonColor.color626262),
                    )
                  ],
                ),
              ),
              AbsorbPointer(
                absorbing: false,
                child: SizedBox(
                  height: MediaQuery.sizeOf(context).width,
                  child: NaverMap(
                    options: NaverMapViewOptions(
                      indoorEnable: true,
                      zoomGesturesEnable: true,
                      locationButtonEnable: false,
                      consumeSymbolTapEvents: false,
                      scrollGesturesEnable: true,
                      tiltGesturesEnable: true,
                      rotationGesturesEnable: true,
                      stopGesturesEnable: true,
                      initialCameraPosition: NCameraPosition(
                        target: NLatLng(
                          controller.spaceDetail['location']['lan'].latitude,
                          controller.spaceDetail['location']['lan'].longitude,
                        ),
                        zoom: 15,
                      ),
                    ),
                    onMapReady: (NaverMapController mapController) async {
                      // 마커 추가
                      final marker = NMarker(
                        id: 'location_marker',
                        position: NLatLng(
                          controller.spaceDetail['location']['lan'].latitude,
                          controller.spaceDetail['location']['lan'].longitude,
                        ),
                      );

                      // // 마커 정보창 추가
                      // final infoWindow = NInfoWindow.onMarker(
                      //   id: 'info_window',
                      //   text: '현재 위치',
                      // );

                      // 마커 클릭 이벤트
                      marker.setOnTapListener((marker) {});

                      // 지도에 마커와 정보창 추가
                      await mapController.addOverlay(marker);
                      // await mapController.addOverlay(infoWindow);
                    },
                  ),
                ),
              ),
              const GlobalBusinessInfoWidget(),
            ])));
  }
}

Widget underscoreText(String text) {
  return Container(
    margin: EdgeInsets.only(left: 24.w, bottom: 24.h),
    decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(width: 2.h, color: CommonColor.colorF0E68C))),
    child: Text(
      text,
      style: TextStyle(
          fontSize: 16.sp,
          fontVariations: CommonStyle.fontWeight800,
          color: CommonColor.color070707),
    ),
  );
}

Widget textList(List list) {
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: 24.w),
    child: ListView.builder(
        primary: false,
        shrinkWrap: true,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 16.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${index + 1}',
                  style: TextStyle(
                      fontSize: 14.sp,
                      fontVariations: CommonStyle.fontWeight800,
                      color: const Color(0xffD6C634)),
                ),
                SizedBox(
                  width: 16.w,
                ),
                Expanded(
                  child: Text(
                    list[index],
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontVariations: CommonStyle.fontWeight600,
                        color: CommonColor.color626262),
                  ),
                )
              ],
            ),
          );
        }),
  );
}
