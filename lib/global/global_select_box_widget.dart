import 'package:flexpace/common/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalSelectBoxWidget extends StatelessWidget {
  final Color? boxColor;
  final Color? textColor;
  final String text;
  final TextStyle? style;
  final Function tap;

  const GlobalSelectBoxWidget({
    super.key,
    this.boxColor,
    this.textColor,
    required this.text,
    this.style,
    required this.tap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        tap();
      },
      child: Container(
        width: MediaQuery.sizeOf(context).width,
        height: 52.h,
        decoration: BoxDecoration(color: boxColor ?? CommonColor.colorF0E68C),
        child: Center(
          child: Text(
            text,
            style: style ??
                TextStyle(
                    fontSize: 16.sp,
                    fontVariations: CommonStyle.fontWeight600,
                    color: textColor ?? CommonColor.color070707),
          ),
        ),
      ),
    );
  }
}
