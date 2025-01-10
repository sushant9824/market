import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validation/form_validation.dart';
import 'package:get/get.dart';
import 'package:market_app/constant/colors.dart';

import '../../../constant/common widget/custom_button.dart';
import '../../../constant/common widget/custom_text_form.dart';
import '../../../constant/font_styles.dart';
import '../../../constant/text_styles.dart';
import 'verification.dart';

class PasswordReset extends ConsumerStatefulWidget {
  const PasswordReset({super.key});

  @override
  ConsumerState<PasswordReset> createState() => _PasswordResetState();
}

class _PasswordResetState extends ConsumerState<PasswordReset> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Forgot Password',
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
                  'Enter Your Phone Number',
                  textAlign: TextAlign.center,
                  style: TextStyles.labelTextStyle,
                ),
                SizedBox(
                  height: 12.h,
                ),
                const Text(
                  'Enter the phone number to get Verification Code to reset password',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontFamily: FontStyles.poppins),
                ),
                SizedBox(
                  height: 12.h,
                ),
                CustomTextForm(
                    controller: phoneNumberController,
                    labelText: 'Phone',
                    hintText: '98********',
                    iconWidget: const Icon(Icons.phone_outlined,
                        size: 22, color: primaryColor),
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      final validator = Validator(validators: [
                        const RequiredValidator(),
                        const MinLengthValidator(length: 10),
                        const MaxLengthValidator(length: 10)
                      ]);
                      return validator.validate(
                        label: 'Phone Number',
                        value: val,
                      );
                    }),
                Text('This code expires in 5 minutes',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontFamily: FontStyles.poppins)),
                SizedBox(
                  height: 24.h,
                ),
                CustomButton(
                    onPressed: () {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        int randomNum = Random().nextInt(900000) + 100000;
                        print('randomNum: $randomNum');
                        Get.to(
                            () => Verification(
                                phoneNumber: phoneNumberController.text.trim(),
                                otpCode: randomNum),
                            transition: Transition.leftToRight);
                      }
                    },
                    text: 'Send')
              ],
            )
          ],
        ),
      ),
    );
  }
}
