import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';
import '../text_styles.dart';

class CustomButton extends StatelessWidget {
  void Function()? onPressed;
  String text;

  CustomButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            minimumSize: Size(double.infinity, 45.h),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0))),
        child: Text(
          text,
          style: TextStyles.btnStyles,
        ));
  }
}
