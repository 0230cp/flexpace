import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_button_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TermsConfirmWidget extends StatelessWidget {
  const TermsConfirmWidget({
    super.key,

    required this.onSubmit, required this.termsList, required this.isTerms,
  });

  final bool isTerms;

  final List termsList;
  final void Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    return  Material(
      child: Center(
        child: Container(
          width: 333.w,
          height: 723.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Padding(
            padding:  EdgeInsets.symmetric(horizontal: 14.w,vertical: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isTerms
                  ? '이용약관'
                  : '개인정보처리방침',
                  style: TextStyle(
                    color: CommonColor.color070707,
                    fontSize: 20.sp,
                    fontVariations: CommonStyle.fontWeight800,
                  ),
                ),

                Padding(
                  padding:  EdgeInsets.symmetric(vertical: 8.h),
                  child: Text(
                    isTerms
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

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: termsList.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(termsList[index]['title'],     style: TextStyle(
                            color: CommonColor.color070707,
                            fontSize: 12.sp,
                            fontVariations: CommonStyle.fontWeight800,
                          ),),


                          Padding(
                            padding:  EdgeInsets.only(top: 8.h,bottom: 20.h),
                            child: Text(termsList[index]['contents'],     style: TextStyle(
                              color: CommonColor.color626262,
                              fontSize: 12.sp,
                              fontVariations: CommonStyle.fontWeight700,
                            ),),
                          ),
                        ],
                      );
                    },
                  ),
                ),





                InkWell(
                  onTap: onSubmit,
                  child: GlobalButtonWidget(text: '확인', textColor: CommonColor.color070707, boxColor: CommonColor.colorF0E68C,

                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );

  }
}
