import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validation/form_validation.dart';
import 'package:get/get.dart';
import 'package:market_app/constant/colors.dart';
import 'package:market_app/provider/auth_provider.dart';

import '../../../constant/common widget/custom_button.dart';
import '../../../constant/common widget/custom_text_form.dart';
import '../../../constant/common widget/toast_alert.dart';
import '../../../constant/text_styles.dart';

class PasswordCreate extends ConsumerStatefulWidget {
  final String phoneNumber;
  PasswordCreate({required this.phoneNumber});

  @override
  ConsumerState<PasswordCreate> createState() => _PasswordCreateState();
}

class _PasswordCreateState extends ConsumerState<PasswordCreate> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool obscureText1 = true;

  TextEditingController newPasswordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (previous, next) {
      if (next.isError) {
        Toasts.showFormFailure(next.errMessage);
      } else if (next.isSuccess) {
        Navigator.of(context).popUntil((route) => route.isFirst);
        Toasts.showSuccess('Password Updated Successfully !!');
      }
    });
    final auth = ref.watch(loginProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'New Password',
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
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            CustomTextForm(
                controller: newPasswordController,
                labelText: 'Password',
                hintText: '*************',
                iconWidget:
                    const Icon(Icons.lock_open, size: 22, color: primaryColor),
                obscureText: obscureText,
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  setState(() {});
                },
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText = !obscureText;
                      });
                    },
                    icon: obscureText
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)),
                validator: (val) {
                  final validator = Validator(validators: [
                    const RequiredValidator(),
                    const MinLengthValidator(length: 8)
                  ]);
                  return validator.validate(
                    label: 'Password',
                    value: val,
                  );
                }),
            CustomTextForm(
                controller: cPasswordController,
                labelText: 'Password',
                hintText: '*************',
                iconWidget:
                    const Icon(Icons.lock_open, size: 22, color: primaryColor),
                obscureText: obscureText1,
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  setState(() {});
                },
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText1 = !obscureText1;
                      });
                    },
                    icon: obscureText1
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)),
                validator: (val) {
                  final validator = Validator(validators: [
                    const RequiredValidator(),
                    const MinLengthValidator(length: 8)
                  ]);
                  return validator.validate(
                    label: 'Password',
                    value: val,
                  );
                }),
            SizedBox(
              height: 14.h,
            ),
            CustomButton(
                onPressed: () {
                  _formKey.currentState!.save();
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    if (newPasswordController.text.trim() ==
                        cPasswordController.text.trim()) {
                      ref.read(loginProvider.notifier).resetPassword(
                          newPassword: newPasswordController.text.trim(),
                          confirmPassword: cPasswordController.text.trim(),
                          phoneNumber: int.parse(widget.phoneNumber));
                    } else {
                      Toasts.showFormFailure(
                          'Password and Confirm Password doesn\'t match');
                    }
                  } else {
                    Toasts.showFormFailure(
                        'Please fill in all required fields');
                  }
                },
                text: auth.isLoad ? 'please wait' : 'Submit')
          ],
        ),
      ),
    );
  }
}
