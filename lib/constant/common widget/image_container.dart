import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_app/constant/text_styles.dart';

import '../colors.dart';

class ImageContainer extends StatelessWidget {
  List<Widget>? actions;
  Widget? child;

  ImageContainer({required this.child, required this.actions});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.defaultDialog(
          content: Text(
            'Choose from',
            style: TextStyles.hintStyle,
          ),
          actions: actions,
        );
      },
      child: Padding(
        padding: EdgeInsets.only(bottom: 16.w),
        child: Container(
          alignment: Alignment.center,
          height: 160.h,
          width: double.infinity,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.0),
              color: primaryColor.withOpacity(0.2)),
          child: child,
        ),
      ),
    );
  }
}
