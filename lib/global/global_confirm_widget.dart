import 'package:flexpace/common/common.dart';
import 'package:flexpace/global/global_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalConfirmWidget extends StatelessWidget {
  const GlobalConfirmWidget({
    super.key,
    required this.title,
    required this.content,
    required this.onSubmit,
  });

  final String title;
  final String content;
  final void Function()? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding:  EdgeInsets.all(14.r),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 16.sp,
                      bottom: 18.sp,
                    ),
                    child: Text(
                      content,
                      textAlign: TextAlign.center,
                      style:  TextStyle(
                          fontSize: 14.sp, color: Color(0xFF222222)),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                          child: GlobalButtonWidget(text: '아니오', textColor:  Color(0xFF222222), boxColor: CommonColor.colorF0E68C,

                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child:InkWell(
                          onTap: (){
                            onSubmit!();
                          },
                          child: GlobalButtonWidget(text: '네', textColor:  Colors.white, boxColor: CommonColor.color1770C2,

                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
