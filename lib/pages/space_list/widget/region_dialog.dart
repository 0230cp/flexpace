import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_select_box_widget.dart';
import 'package:flexpace/pages/space_list/widget/title_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class RegionDialog extends StatelessWidget {
  final Map<String, List> regionList;
  final Function(String) regionTap;
  final Function(int) regionListTap;
  final Function boxTap;
  final String regionType;
  final String region;

  const RegionDialog({
    super.key,
    required this.regionList,
    required this.regionType,
    required this.region,
    required this.regionTap,
    required this.regionListTap,
    required this.boxTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(color: Colors.white),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Column(
              children: [
                const TitleBox(title: '지역선택'),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 52.h),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border(
                                    right: BorderSide(
                                        width: 1.w,
                                        color: CommonColor.colorDDDDDD))),
                            child: ListView(
                              children: regionList.entries.map((item) {
                                return InkWell(
                                  onTap: () {
                                    regionTap(item.key);
                                  },
                                  child: Container(
                                    width: 160.w,
                                    height: 49.h,
                                    decoration: BoxDecoration(
                                      color: region == item.key
                                          ? CommonColor.colorF0E68C
                                          : Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 1.w,
                                          color: CommonColor.colorDDDDDD,
                                        ),
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24.w),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Row(
                                        children: [
                                          Text(
                                            item.key,
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontVariations:
                                                  CommonStyle.fontWeight500,
                                              color: region == item.key
                                                  ? CommonColor.color070707
                                                  : CommonColor.color626262,
                                            ),
                                          ),
                                          const Spacer(),
                                          Text(
                                            item.value.isEmpty
                                                ? ''
                                                : '${item.value.length}',
                                            style: TextStyle(
                                              fontSize: 14.sp,
                                              fontVariations:
                                                  CommonStyle.fontWeight500,
                                              color: region == item.key
                                                  ? CommonColor.color070707
                                                  : CommonColor.color626262,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                              primary: false,
                              shrinkWrap: true,
                              itemCount: regionList[region]!.length,
                              itemBuilder: (context, index) {
                                return InkWell(
                                  onTap: () {
                                    regionListTap(index);
                                  },
                                  child: Container(
                                    height: 49.h,
                                    decoration: BoxDecoration(
                                      color: regionType ==
                                              regionList[region]![index]
                                          ? CommonColor.colorF0E68C
                                          : Colors.white,
                                      border: Border(
                                        bottom: BorderSide(
                                            width: 1.w,
                                            color: CommonColor.colorDDDDDD),
                                      ),
                                    ),
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 24.w),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        '${regionList[region]![index]}',
                                        style: TextStyle(
                                            fontSize: 14.sp,
                                            fontVariations:
                                                CommonStyle.fontWeight500,
                                            color: regionType ==
                                                    regionList[region]![index]
                                                ? CommonColor.color070707
                                                : CommonColor.color626262),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
            GlobalSelectBoxWidget(
              text: '선택완료',
              tap: () {
                boxTap();
              },
              textColor: regionType.isEmpty
                  ? CommonColor.colorBFBFBF
                  : CommonColor.color070707,
              boxColor: regionType.isEmpty
                  ? CommonColor.colorDDDDDD
                  : CommonColor.colorF0E68C,
            )
          ],
        ),
      ),
    );
  }
}
