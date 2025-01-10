import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../constant/text_styles.dart';

class ProfileInfo extends StatelessWidget {
  String text;
  Widget iconWidget;
  ProfileInfo(this.text, this.iconWidget);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            iconWidget,
            SizedBox(
              width: 8.w,
            ),
            Text(
              text,
              style: TextStyles.detailStyle,
            ),
          ],
        ),
        SizedBox(
          height: 12.h,
        ),
      ],
    );
  }
}
