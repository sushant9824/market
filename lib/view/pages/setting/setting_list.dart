import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constant/colors.dart';
import '../../../constant/text_styles.dart';

class SettingList extends StatelessWidget {
  final String text;
  void Function()? onTap;
  Widget? widget;
  SettingList({
    required this.text,
    required this.onTap,
    this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: primaryColor.withOpacity(0.4),
      radius: 80.r,
      borderRadius: BorderRadius.circular(8.0),
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.r, horizontal: 4.r),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              text,
              style: TextStyles.settingStyles,
            ),
            if (widget != null) widget!,
          ],
        ),
      ),
    );
  }
}
