import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'colors.dart';
import 'font_styles.dart';

class FontSizes {
  static final s10 = 10.sp;
  static final s12 = 12.sp;
  static final s13 = 13.sp;
  static final s14 = 14.sp;
  static final s15 = 15.sp;
  static final s16 = 16.sp;
  static final s17 = 17.sp;
  static final s18 = 18.sp;
  static final s19 = 19.sp;
  static final s20 = 20.sp;
}

class TextStyles {
  static TextStyle headingStyle = TextStyle(
      fontWeight: FontStyles.medium700,
      fontSize: FontSizes.s20,
      fontFamily: FontStyles.poppins);

  static TextStyle labelTextStyle = TextStyle(
      fontSize: FontSizes.s16,
      fontFamily: FontStyles.poppins,
      fontWeight: FontStyles.medium600);

  static TextStyle btnStyles = TextStyle(
      color: whiteColor,
      fontSize: FontSizes.s15,
      fontFamily: FontStyles.poppins,
      fontWeight: FontStyles.medium600);

  static TextStyle textFieldStyle = TextStyle(fontFamily: FontStyles.poppins);

  static TextStyle settingStyles =
      TextStyle(fontFamily: FontStyles.poppins, fontSize: FontSizes.s16);

  static TextStyle hintStyle = TextStyle(
      fontSize: FontSizes.s14,
      fontFamily: FontStyles.poppins,
      color: labelBlack.withOpacity(0.8));

  static TextStyle infoStyle = TextStyle(
      fontFamily: FontStyles.poppins,
      fontWeight: FontStyles.medium600,
      fontSize: FontSizes.s12,
      color: lightGreyColor);

  static TextStyle detailStyle =
      TextStyle(fontFamily: FontStyles.poppins, fontSize: FontSizes.s14);

  static TextStyle tileTitle = TextStyle(
      color: textBlack,
      fontFamily: FontStyles.poppins,
      fontWeight: FontStyles.medium600,
      fontSize: FontSizes.s17);
}
