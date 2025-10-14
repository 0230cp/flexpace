import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_select_box_widget.dart';
import 'package:flexpace/pages/space_list/widget/title_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PeopleDialog extends StatelessWidget {
  final List peopleList;
  final String people;
  final Function tap;
  final Function boxTap;

  const PeopleDialog(
      {super.key,
      required this.peopleList,
      required this.people,
      required this.tap,
      required this.boxTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: MediaQuery.sizeOf(context).height,
        decoration: const BoxDecoration(color: Colors.white),
        child: Column(
          children: [
            const TitleBox(title: '인원수 선택'),
            Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: BoxDecoration(color: CommonColor.colorDDDDDD),
              padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 24.w),
              child: Text(
                '최대 인원수를 기준으로 목록이 표시됩니다.',
                style: TextStyle(
                    fontSize: 14.sp,
                    fontVariations: CommonStyle.fontWeight600,
                    color: CommonColor.color626262),
              ),
            ),
            ...List.generate(
                peopleList.length,
                (index) => InkWell(
                      onTap: () {
                        tap(index);
                      },
                      child: Container(
                        width: MediaQuery.sizeOf(context).width,
                        decoration: BoxDecoration(
                            color: people == peopleList[index]
                                ? CommonColor.colorF0E68C
                                : Colors.white,
                            border: Border(
                                bottom: BorderSide(
                                    width: 1.w,
                                    color: CommonColor.colorDDDDDD))),
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.w, vertical: 16.h),
                        child: Text(
                          peopleList[index],
                          style: TextStyle(
                              fontSize: 14.sp,
                              fontVariations: CommonStyle.fontWeight500,
                              color: people == peopleList[index]
                                  ? CommonColor.color070707
                                  : CommonColor.color626262),
                        ),
                      ),
                    )),
            const Spacer(),
            GlobalSelectBoxWidget(
              text: '선택완료',
              tap: () {
                boxTap();
              },
              textColor: people.isEmpty
                  ? CommonColor.colorBFBFBF
                  : CommonColor.color070707,
              boxColor: people.isEmpty
                  ? CommonColor.colorDDDDDD
                  : CommonColor.colorF0E68C,
            )
          ],
        ),
      ),
    );
  }
}
