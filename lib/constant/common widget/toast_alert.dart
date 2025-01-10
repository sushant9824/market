import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../colors.dart';

class Toasts {
  static showFailure(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.CENTER,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.pink.shade600,
      textColor: Colors.white,
      fontSize: 16.sp,
    );
  }

  static showFormFailure(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
      msg: message,
      gravity: ToastGravity.BOTTOM,
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.pink.shade600,
      textColor: Colors.white,
      fontSize: 16.sp,
    );
  }

  static authShowFailure(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.pink.shade600,
        textColor: Colors.white,
        fontSize: 16.sp);
  }

  static showSuccess(String message) {
    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: message,
        gravity: ToastGravity.BOTTOM,
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: primaryColor,
        textColor: Colors.white,
        fontSize: 16.sp);
  }
}
