import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pinput/pinput.dart';

import '../../constant/app_sizes.dart';
import '../../constant/colors.dart';
import '../../constant/common widget/custom_button.dart';
import '../../constant/common widget/toast_alert.dart';
import '../../constant/font_styles.dart';
import '../../constant/text_styles.dart';
import '../../provider/auth_provider.dart';

class RegisterOtp extends ConsumerStatefulWidget {
  final String firstName;
  final String lastName;
  final String mobileNumber;
  final String email;
  final String password;
  final XFile image;
  int otpCode;
  RegisterOtp({
    required this.firstName,
    required this.lastName,
    required this.mobileNumber,
    required this.email,
    required this.password,
    required this.image,
    required this.otpCode,
  });

  @override
  ConsumerState<RegisterOtp> createState() => _RegisterOtpState();
}

class _RegisterOtpState extends ConsumerState<RegisterOtp> {
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
    ref.listen(registerProvider, (previous, next) {
      if (next.isError) {
        Toasts.showFormFailure(next.errMessage);
      } else if (next.isSuccess) {
        Toasts.showSuccess('User Created Successfully !!');
        Navigator.of(context).popUntil((route) => route.isFirst);
      }
    });
    final auth = ref.watch(registerProvider);

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
                  'The Verification Code was sent to your number +977 ${widget.mobileNumber.substring(0, 3)}#####${widget.mobileNumber.substring(8, 10)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontFamily: FontStyles.poppins),
                ),
                gapH12,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Didn\'t get code? ',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontFamily: FontStyles.poppins)),
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
                          ref.read(registerProvider.notifier).userRegister(
                              firstName: widget.firstName,
                              lastName: widget.lastName,
                              mobileNumber: widget.mobileNumber,
                              email: widget.email,
                              password: widget.password,
                              profilePicture: widget.image);
                        } else {
                          Toasts.showFailure('invalid otp code');
                        }
                      }
                    },
                    text: auth.isLoad ? 'please wait' : 'Verify Code'),
                Text(widget.otpCode.toString())
              ],
            )
          ],
        ),
      ),
    );
  }
}
