import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:market_app/constant/app_sizes.dart';
import 'package:market_app/constant/common%20widget/toast_alert.dart';
import 'package:market_app/provider/image_picker_provider.dart';
import 'package:market_app/view/pages/password_reset/password_create.dart';
import 'package:pinput/pinput.dart';

import '../../../constant/colors.dart';
import '../../../constant/common widget/custom_button.dart';
import '../../../constant/font_styles.dart';
import '../../../constant/text_styles.dart';

class Verification extends StatefulWidget {
  final String phoneNumber;
  int otpCode;
  Verification({required this.phoneNumber, required this.otpCode});

  @override
  State<Verification> createState() => _VerificationState();
}

class _VerificationState extends State<Verification> {
  int secondsRemaining = 30;
  Timer? timer;

  final defaultPinTheme = PinTheme(
    width: 45,
    height: 45,
    textStyle: TextStyles.labelTextStyle,
    decoration: BoxDecoration(
      border: Border.all(color: primaryColor.withOpacity(0.6)),
      borderRadius: BorderRadius.circular(90.0),
    ),
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    timer = Timer.periodic(Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  void _resendCode() {
    //resend code here
    int regenerateRandomNum = Random().nextInt(900000) + 100000;
    widget.otpCode = regenerateRandomNum;
    print('randomNum: $regenerateRandomNum');
    setState(() {
      secondsRemaining = 30;
    });
  }

  @override
  dispose() {
    timer?.cancel();
    super.dispose();
  }

  final _formKey = GlobalKey<FormState>();
  TextEditingController otpCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Verification',
          style: TextStyles.headingStyle,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.r),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.01,
            ),
            Column(
              children: [
                Text(
                  'Enter Verification Code',
                  textAlign: TextAlign.center,
                  style: TextStyles.labelTextStyle,
                ),
                gapH12,
                Pinput(
                  controller: otpCodeController,
                  defaultPinTheme: defaultPinTheme,
                  length: 6,
                  validator: (val) {
                    if (val == null || val.isEmpty || val.length < 6) {
                      return 'Enter a valid 6-digit PIN';
                    }
                    return null;
                  },
                ),
                gapH12,
                Text(
                  'The Verification Code was sent to your number +977 ${widget.phoneNumber.substring(0, 3)}#####${widget.phoneNumber.substring(8, 10)}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: FontStyles.poppins),
                ),
                gapH12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Didn\'t get code? ',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontFamily: FontStyles.poppins),
                    ),
                    secondsRemaining != 0
                        ? Text(
                            ' $secondsRemaining seconds remaining',
                            style:
                                TextStyle(fontSize: 14.sp, color: Colors.grey),
                          )
                        : InkWell(
                            onTap: () {
                              _resendCode();
                            },
                            child: const Text(
                              'Resend Code',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: FontStyles.poppins,
                                  color: primaryColor,
                                  fontWeight: FontStyles.medium600),
                            )),
                  ],
                ),
                SizedBox(
                  height: 30.h,
                ),
                CustomButton(
                    onPressed: () {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        if (otpCodeController.text.trim() ==
                            widget.otpCode.toString()) {
                          Get.to(
                              () => PasswordCreate(
                                  phoneNumber: widget.phoneNumber),
                              transition: Transition.leftToRight);
                        } else {
                          Toasts.showFailure('invalid otp code');
                        }
                      }
                    },
                    text: 'Verify Code'),
                Text(widget.otpCode.toString())
              ],
            )
          ],
        ),
      ),
    );
  }
}
