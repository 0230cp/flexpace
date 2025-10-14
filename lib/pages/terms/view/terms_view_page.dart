import 'package:flexpace/common/common.dart';
import 'package:flexpace/common/send_sms.dart';
import 'package:flexpace/global/global_appbar_widget.dart';
import 'package:flexpace/global/global_business_info_widget.dart';
import 'package:flexpace/global/global_sidebar_widget.dart';
import 'package:flexpace/pages/reseve/controller/reserve_controller.dart';
import 'package:flexpace/pages/reseve/widget/reserve_widget.dart';
import 'package:flexpace/pages/terms/controller/terms_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../global/global_layout_widget.dart';

class TermsViewPage extends GetView<TermsController> {
  const TermsViewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GlobalLayoutWidget(
        context: context,
        appBar: const GlobalAppbarWidget(),
        drawer: GlobalSidebarWidget(),
        body: SingleChildScrollView(
          controller: controller.scrollController,
          child:  Obx(()=> Column(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width,
                color: CommonColor.colorF5F5F5,
                child: Padding(
                  padding: EdgeInsets.only(top: 42.h, bottom: 23.h),
                  child: Center(
                    child: Text(
                      controller.isTerms.value ?    '이용약관' : '개인정보처리방침',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontVariations: const [
                          FontVariation('wght', 800), // 폰트 두께
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding:  EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  children: [
                    SizedBox(height: 16.h,),
                    Padding(
                      padding:  EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        controller.isTerms.value
                            ? '본 이용약관은 FLEXPACE 앱(이하 "앱")의 이용에 대한 조건을 규정합니다. 본 약관에 동의함으로써, 앱의 이용자가 됨을 인정하고, 이용자는 약관에 명시된 모든 조항을 준수할 의무가 있습니다.'
                            : "진피아(Jinpia) (이하 '회사')는 정보통신망 이용촉진 및 정보보호 등에 관한 법률(이하 '정보통신망법') 등에 따라 회원의 개인정보를 보호하고, 관련된 고충을 신속하고 원활하게 처리할 수 있도록 다음과 같이 개인정보처리방침을 수립하여 공개합니다.",
                        style: TextStyle(
                          color: const Color(0xffABABAB),
                          fontSize: 12.sp,
                          fontVariations: CommonStyle.fontWeight400,
                        ),
                      ),
                    ),

                    Container(width: MediaQuery.sizeOf(context).width,height: 1.h,color: CommonColor.colorDFDFDF,margin: EdgeInsets.symmetric(vertical: 12.h),),

                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.isTerms.value ? controller.termsList.length : controller.privacyList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(controller.isTerms.value ? controller.termsList[index]['title'] : controller.privacyList[index]['title'],     style: TextStyle(
                              color: CommonColor.color070707,
                              fontSize: 12.sp,
                              fontVariations: CommonStyle.fontWeight800,
                            ),),


                            Padding(
                              padding:  EdgeInsets.only(top: 8.h,bottom: 20.h),
                              child: Text(controller.isTerms.value ? controller.termsList[index]['contents'] : controller.privacyList[index]['contents'],     style: TextStyle(
                                color: CommonColor.color626262,
                                fontSize: 12.sp,
                                fontVariations: CommonStyle.fontWeight700,
                              ),),
                            ),
                          ],
                        );
                      },
                    ),



                  ],
                ),
              ),
              const GlobalBusinessInfoWidget(),

            ],
          ),),
        ));
  }
}
