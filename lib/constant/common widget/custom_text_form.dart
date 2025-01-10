import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../colors.dart';
import '../text_styles.dart';

class CustomTextForm extends StatelessWidget {
  String labelText;
  String hintText;
  Widget? iconWidget;
  TextEditingController? controller;
  bool obscureText;
  TextInputType? keyboardType;
  void Function(String)? onChanged;
  Widget? suffixIcon;
  String? Function(String?)? validator;
  bool enabled;
  void Function()? onTap;
  int? maxLines;

  CustomTextForm(
      {required this.labelText,
      required this.hintText,
      this.iconWidget,
      this.controller,
      this.obscureText = false,
      this.keyboardType,
      this.onChanged,
      this.suffixIcon,
      this.validator,
      this.onTap,
      this.maxLines = 1,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (iconWidget != null) iconWidget!,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 6.0),
                child: Text(labelText, style: TextStyles.labelTextStyle),
              ),
            ],
          ),
          SizedBox(height: 6.h),
          GestureDetector(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0)),
              child: TextFormField(
                enabled: enabled,
                maxLines: maxLines,
                controller: controller,
                obscureText: obscureText,
                keyboardType: keyboardType,
                onChanged: onChanged,
                textInputAction: TextInputAction.next,
                cursorColor: primaryColor,
                validator: validator,
                style: TextStyles.textFieldStyle,
                decoration: InputDecoration(
                  suffixIcon: suffixIcon,
                  hintText: hintText,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12.r, vertical: 14.r),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: Colors.grey.shade500)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide(color: primaryColor)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
