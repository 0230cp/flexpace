import 'package:flexpace/common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class GlobalTextField extends StatelessWidget {
  const GlobalTextField(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      required this.onChanged,
      required this.isExist,
      this.isNumber = false,
      this.certificationNumber = false,
      this.isReadOnly = false,
      this.focusNode,
      this.suffix});

  final TextEditingController textEditingController;

  final String hintText;

  final Function onChanged;

  final bool isExist;

  final FocusNode? focusNode;

  final bool isNumber;

  final bool certificationNumber;

  final bool isReadOnly;

  final Widget? suffix;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: 52.h,
        child: TextField(
          onChanged: (value) {
            onChanged(value);
          },
          focusNode: focusNode,
          cursorColor: CommonColor.color070707,
          textAlign: TextAlign.start,
          controller: textEditingController,
          style: TextStyle(
              color: isReadOnly ? CommonColor.colorBFBFBF : CommonColor.color070707,
              fontSize: 16.sp,
            fontVariations: CommonStyle.fontWeight500,
          ),
          keyboardType:
              isNumber ? TextInputType.number : TextInputType.emailAddress,
          readOnly: isReadOnly,
          decoration: InputDecoration(
              hintText: hintText,
              suffixIcon: suffix,
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              hintStyle: TextStyle(
                  color: CommonColor.colorBFBFBF,
                  fontSize: 16.sp,
                fontVariations: CommonStyle.fontWeight500,),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(
                      color: isExist
                          ? const Color(0xffFF6A74)
                          : CommonColor.colorBFBFBF)),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(
                    color: isExist
                        ? const Color(0xffFF6A74)
                        : CommonColor.colorBFBFBF),
              ),
              filled: true,
              fillColor: isReadOnly ? CommonColor.colorF5F5F5 :  Colors.white),
        ));
  }
}
