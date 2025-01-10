import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validation/form_validation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_app/provider/autoValidate_provider.dart';
import 'package:market_app/view/auth/register_otp.dart';
import '../../constant/colors.dart';
import '../../constant/common widget/custom_button.dart';
import '../../constant/common widget/custom_text_form.dart';
import '../../constant/common widget/toast_alert.dart';
import '../../constant/font_styles.dart';
import '../../constant/text_styles.dart';
import '../../provider/auth_provider.dart';
import '../../provider/image_picker_provider.dart';

class Register extends ConsumerStatefulWidget {
  const Register({super.key});

  @override
  ConsumerState<Register> createState() => _RegisterState();
}

class _RegisterState extends ConsumerState<Register> {
  bool obscureText = true;
  bool obscureText1 = true;
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController cPasswordController = TextEditingController();

  //**check image size */
  Future<bool> isImageSizeValid(XFile imageXFile, int maxSizeInBytes) async {
    final imageFile = File(imageXFile.path); // Convert XFile to File
    final fileLength = await imageFile.length();
    return fileLength <= maxSizeInBytes;
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(registerProvider);
    final image = ref.watch(imageProvider);
    final mode = ref.watch(autoValidateMode);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Register',
          style: TextStyles.headingStyle,
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Form(
        key: _formKey,
        autovalidateMode: mode,
        child: ListView(
          padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 16.w),
          children: [
            GestureDetector(
              onTap: () {
                Get.defaultDialog(
                  content: Text(
                    'Choose image from',
                    style: TextStyles.textFieldStyle,
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.read(imageProvider.notifier).imagePick(true);
                      },
                      child: const Text('Camera'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        ref.read(imageProvider.notifier).imagePick(false);
                      },
                      child: const Text('Gallery'),
                    ),
                  ],
                );
              },
              child: image != null
                  ? CircleAvatar(
                      radius: 65.r,
                      backgroundImage: FileImage(File(image.path)),
                    )
                  : CircleAvatar(
                      radius: 65.r,
                      backgroundColor: primaryColor.withOpacity(0.4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.add_a_photo,
                            color: primaryColor,
                          ),
                          Text('Upload an Image',
                              style: TextStyle(
                                  fontFamily: FontStyles.poppins,
                                  fontSize: FontSizes.s12)),
                        ],
                      )),
            ),
            SizedBox(
              height: 10.w,
            ),
            Row(
              children: [
                Flexible(
                    child: CustomTextForm(
                        controller: firstNameController,
                        labelText: 'First Name',
                        hintText: 'Your First Name',
                        iconWidget: const Icon(
                          Icons.person_2_outlined,
                          size: 22,
                          color: textIconColor,
                        ),
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          final validator = Validator(
                              validators: [const RequiredValidator()]);
                          return validator.validate(
                            label: 'First Name',
                            value: val,
                          );
                        })),
                SizedBox(
                  width: 12.w,
                ),
                Flexible(
                    child: CustomTextForm(
                        controller: lastNameController,
                        labelText: 'Last Name',
                        hintText: 'Your Last Name',
                        iconWidget: const Icon(Icons.person_2_outlined,
                            size: 22, color: textIconColor),
                        keyboardType: TextInputType.text,
                        validator: (val) {
                          final validator = Validator(
                              validators: [const RequiredValidator()]);
                          return validator.validate(
                            label: 'Last Name',
                            value: val,
                          );
                        }))
              ],
            ),
            CustomTextForm(
                controller: phoneNumberController,
                labelText: 'Phone Number',
                hintText: '98********',
                keyboardType: TextInputType.number,
                iconWidget: const Icon(Icons.phone_outlined,
                    size: 22, color: textIconColor),
                validator: (val) {
                  final validator = Validator(validators: [
                    const RequiredValidator(),
                    const NumberValidator(),
                    const MinLengthValidator(length: 10),
                    const MaxLengthValidator(length: 10)
                  ]);
                  return validator.validate(
                    label: 'Phone Number',
                    value: val,
                  );
                }),
            CustomTextForm(
                controller: emailController,
                labelText: 'Email',
                hintText: 'example@gmail.com',
                keyboardType: TextInputType.emailAddress,
                iconWidget: const Icon(Icons.email_outlined,
                    size: 22, color: textIconColor),
                validator: (val) {
                  final validator = Validator(validators: [
                    const RequiredValidator(),
                    const EmailValidator()
                  ]);
                  return validator.validate(
                    label: 'Email',
                    value: val,
                  );
                }),
            CustomTextForm(
                controller: passwordController,
                labelText: 'Password',
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
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility)),
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
            Row(
              children: [
                Checkbox(
                  value: isChecked,
                  onChanged: (bool? value) {
                    setState(() {
                      isChecked = value!;
                    });
                  },
                  fillColor: MaterialStateColor.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return textIconColor;
                    }
                    return textIconColor;
                  }),
                  checkColor: Colors.white,
                ),
                const Flexible(
                  child: Text(
                    'I have read and agree to the terms and conditions.',
                    style: TextStyle(
                        fontFamily: FontStyles.poppins,
                        fontWeight: FontStyles.medium600),
                  ),
                )
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            CustomButton(
                onPressed: () async {
                  _formKey.currentState!.save();
                  FocusScope.of(context).unfocus();
                  if (_formKey.currentState!.validate()) {
                    if (isChecked) {
                      if (passwordController.text.trim() ==
                          cPasswordController.text.trim()) {
                        if (image == null) {
                          Toasts.showFormFailure('Image is required');
                        } else {
                          final isValidSize =
                              await isImageSizeValid(image, 10 * 1024 * 1024);
                          if (isValidSize) {
                            int randomNum = Random().nextInt(900000) + 100000;
                            print('randomNum: $randomNum');
                            Get.to(() => RegisterOtp(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  mobileNumber:
                                      phoneNumberController.text.trim(),
                                  email: emailController.text.trim(),
                                  password: cPasswordController.text.trim(),
                                  image: image,
                                  otpCode: randomNum,
                                ));
                          } else {
                            Toasts.showFormFailure(
                                'Image size is too large. Image size shouldn\'t be greater than 10MB.');
                          }
                        }
                      } else {
                        Toasts.showFormFailure(
                            'Password and Confirm Password doesn\'t match');
                      }
                    } else {
                      Toasts.showFormFailure(
                          'Please agree to terms and conditions');
                    }
                  } else {
                    ref.read(autoValidateMode.notifier).toggle();
                    Toasts.showFormFailure(
                        'Please fill in all required fields');
                  }
                },
                text: 'Sign-up'),
          ],
        ),
      ),
    );
  }
}
