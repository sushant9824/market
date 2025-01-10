import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors.dart';
import '../text_styles.dart';

class CustomSearchTextFromFeild extends StatelessWidget {
  const CustomSearchTextFromFeild({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: primaryColor,
      style: TextStyles.textFieldStyle,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 12.w),
          hintText: 'Search',
          hintStyle: TextStyles.textFieldStyle,
          border: OutlineInputBorder(
              borderSide: const BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(10.0)),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(10.0)),
          focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: primaryColor),
              borderRadius: BorderRadius.circular(10.0))),
    );
  }
}
