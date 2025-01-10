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
import '../../../provider/user_detail_provider.dart';
import '../../login_state.dart';

class ChangePassword extends ConsumerStatefulWidget {
  const ChangePassword({super.key});

  @override
  ConsumerState<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends ConsumerState<ChangePassword> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;
  bool obscureText1 = true;
  bool obscureText2 = true;

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(changePasswordProvider, (previous, next) {
      if (next.isError) {
        Toasts.showFormFailure(next.errMessage);
      } else if (next.isSuccess) {
        ref.read(loginProvider.notifier).userLogOut();
        Get.offAll(() => LoginStatus());
        Toasts.showSuccess('Password Changed Successfully !!');
      }
    });
    final auth = ref.watch(loginProvider);
    final changePassword = ref.watch(changePasswordProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
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
                controller: oldPasswordController,
                labelText: 'Old Password',
                hintText: '*************',
                iconWidget:
                    const Icon(Icons.lock_open, size: 22, color: textIconColor),
                obscureText: obscureText2,
                keyboardType: TextInputType.text,
                onChanged: (val) {
                  setState(() {});
                },
                suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        obscureText2 = !obscureText2;
                      });
                    },
                    icon: obscureText2
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility)),
                validator: (val) {
                  final validator = Validator(validators: [
                    const RequiredValidator(),
                    const MinLengthValidator(length: 8)
                  ]);
                  return validator.validate(
                    label: 'Old Password',
                    value: val,
                  );
                }),
            CustomTextForm(
                controller: newPasswordController,
                labelText: 'New Password',
                hintText: '*************',
                iconWidget:
                    const Icon(Icons.lock_open, size: 22, color: textIconColor),
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
                    label: 'New Password',
                    value: val,
                  );
                }),
            CustomTextForm(
                controller: cPasswordController,
                labelText: 'Confirm Password',
                hintText: '*************',
                iconWidget:
                    const Icon(Icons.lock_open, size: 22, color: textIconColor),
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
                    label: 'Confirm Password',
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
                      ref.read(changePasswordProvider.notifier).changePassword(
                          oldPassword: oldPasswordController.text.trim(),
                          newPassword: newPasswordController.text.trim(),
                          confirmPassword: cPasswordController.text.trim(),
                          uID: auth.user[0].userId,
                          token: auth.user[0].token);
                    } else {
                      Toasts.showFormFailure(
                          'Password and Confirm Password doesn\'t match');
                    }
                  } else {
                    Toasts.showFormFailure(
                        'Please fill in all required fields');
                  }
                },
                text: changePassword.isLoad ? 'please wait' : 'Submit')
          ],
        ),
      ),
    );
  }
}
