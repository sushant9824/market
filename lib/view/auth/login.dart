import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validation/form_validation.dart';
import 'package:get/get.dart';
import 'package:market_app/view/auth/register.dart';
import '../../constant/app_sizes.dart';
import '../../constant/colors.dart';
import '../../constant/common widget/custom_button.dart';
import '../../constant/common widget/custom_text_form.dart';
import '../../constant/common widget/toast_alert.dart';
import '../../constant/font_styles.dart';
import '../../constant/text_styles.dart';
import '../../provider/auth_provider.dart';
import '../../provider/autoValidate_provider.dart';
import '../pages/password_reset/password_reset.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  bool obscureText = true;
  final _formKey = GlobalKey<FormState>();

  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(loginProvider, (previous, next) {
      if (next.isError) {
        Toasts.showFormFailure(next.errMessage);
      } else if (next.isSuccess) {
        Toasts.showSuccess('Login Success !!');
      }
    });
    final auth = ref.watch(loginProvider);
    final mode = ref.watch(autoValidateMode);
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          autovalidateMode: mode,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 22.sp),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.06,
              ),
              Image.asset(
                'assets/icons/logo.png',
                height: 100.h,
                width: 80.w,
              ),
              gapH10,
              Center(
                  child: Text(
                'Login to your Account',
                style: TextStyles.headingStyle,
              )),
              SizedBox(height: 22.h),
              CustomTextForm(
                  controller: phoneNumberController,
                  labelText: 'Phone',
                  hintText: '98********',
                  iconWidget: const Icon(
                    Icons.phone_outlined,
                    size: 22,
                    color: textIconColor,
                  ),
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
              CustomTextForm(
                  controller: passwordController,
                  labelText: 'Password',
                  hintText: '*************',
                  iconWidget: const Icon(
                    Icons.lock_open,
                    size: 22,
                    color: textIconColor,
                  ),
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
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility)),
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
              Align(
                  alignment: Alignment.centerRight,
                  child: InkWell(
                      onTap: () {
                        Get.to(() => PasswordReset());
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            color: textIconColor,
                            fontWeight: FontWeight.w400,
                            fontFamily: FontStyles.poppins),
                      ))),
              gapH10,
              CustomButton(
                  onPressed: () {
                    _formKey.currentState!.save();
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      ref.read(loginProvider.notifier).userLogin(
                          mobileNumber: phoneNumberController.text.trim(),
                          password: passwordController.text.trim());
                    } else {
                      ref.read(autoValidateMode.notifier).toggle();
                      Toasts.showFormFailure(
                          'Please fill in all required fields');
                    }
                  },
                  text: auth.isLoad ? 'please wait' : 'Log-in'),
              gapH10,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Don’t have an account? ',
                    style: TextStyle(fontFamily: FontStyles.poppins),
                  ),
                  InkWell(
                      onTap: () {
                        Get.to(() => const Register(),
                            transition: Transition.leftToRight);
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(
                            fontFamily: FontStyles.poppins,
                            color: textIconColor),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
