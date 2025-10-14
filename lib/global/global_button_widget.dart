import 'package:flexpace/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalButtonWidget extends StatelessWidget {
  const GlobalButtonWidget({
    super.key,
    required this.text,
    required this.textColor,
    required this.boxColor,
  });

  final String text;
  final Color textColor;
  final Color boxColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.sizeOf(context).width,
      height: 52.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8), color: boxColor),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
              fontSize: 16.sp,
              fontVariations: CommonStyle.fontWeight500,
              color: textColor),
        ),
      ),
    );
  }
}
