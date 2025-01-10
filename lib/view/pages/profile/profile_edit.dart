import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validation/form_validation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../../constant/colors.dart';
import '../../../constant/common widget/custom_button.dart';
import '../../../constant/common widget/custom_text_form.dart';
import '../../../constant/common widget/toast_alert.dart';
import '../../../constant/text_styles.dart';
import '../../../model/user_detail_model/user_detail.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/image_picker_provider.dart';
import '../../../provider/product_provider.dart';
import '../../../provider/user_detail_provider.dart';

class ProfileEdit extends ConsumerStatefulWidget {
  UserDetail userDetail;
  ProfileEdit({required this.userDetail});

  @override
  ConsumerState<ProfileEdit> createState() => _ProfileEditState();
}

class _ProfileEditState extends ConsumerState<ProfileEdit> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  static Logger logger = Logger();

  //**check image size */
  Future<bool> isImageSizeValid(XFile imageXFile, int maxSizeInBytes) async {
    final imageFile = File(imageXFile.path); // Convert XFile to File
    final fileLength = await imageFile.length();
    return fileLength <= maxSizeInBytes;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    firstNameController.text = widget.userDetail.firstName;
    lastNameController.text = widget.userDetail.lastName;
    phoneNumberController.text = widget.userDetail.mobileNumber;
    emailController.text = widget.userDetail.email;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(userDetailUpdateProvider, (previous, next) {
      if (next.isError) {
        Toasts.showFormFailure(next.errMessage);
      } else if (next.isSuccess) {
        ref.invalidate(userDetailsProvider);
        ref.invalidate(productShow);
        ref.invalidate(productByUidProvider);
        Navigator.of(context).pop();
        Toasts.showSuccess('User Details Updated Successfully !!');
      }
    });
    final auth = ref.watch(loginProvider);
    final userUpdate = ref.watch(userDetailUpdateProvider);
    final image = ref.watch(imageProvider);

    // logger.d(image!.path);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Edit Profile',
            style: TextStyles.headingStyle,
          ),
          centerTitle: true,
          elevation: 0,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: 4.w, horizontal: 16.w),
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  image == null
                      ? CircleAvatar(
                          radius: 80.r,
                          backgroundImage:
                              NetworkImage(widget.userDetail.profilePictureUrl))
                      : CircleAvatar(
                          radius: 80.r,
                          backgroundImage: FileImage(File(image.path)),
                        ),
                  Positioned(
                    bottom: 0,
                    right: 120.r,
                    child: GestureDetector(
                      onTap: () {
                        Get.defaultDialog(
                          content:
                              Text('Choose from', style: TextStyles.hintStyle),
                          actions: [
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: whiteColor),
                              onPressed: () {
                                Navigator.of(context).pop();
                                ref
                                    .read(imageProvider.notifier)
                                    .imagePick(true);
                              },
                              child:
                                  Text('Camera', style: TextStyles.hintStyle),
                            ),
                            TextButton(
                              style: TextButton.styleFrom(
                                  backgroundColor: whiteColor),
                              onPressed: () {
                                Navigator.of(context).pop();
                                ref
                                    .read(imageProvider.notifier)
                                    .imagePick(false);
                              },
                              child:
                                  Text('Gallery', style: TextStyles.hintStyle),
                            ),
                          ],
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: primaryColor.withOpacity(.9),
                        ),
                        padding: EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20.r,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 24.h,
              ),
              Row(
                children: [
                  Flexible(
                      child: CustomTextForm(
                          controller: firstNameController,
                          labelText: 'First Name',
                          hintText: 'Your First Name',
                          iconWidget: const Icon(Icons.person_2_outlined,
                              size: 22, color: textIconColor),
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
                  enabled: false,
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
              SizedBox(
                height: 10.h,
              ),
              CustomButton(
                  onPressed: () async {
                    _formKey.currentState!.save();
                    FocusScope.of(context).unfocus();
                    if (_formKey.currentState!.validate()) {
                      if (image == null) {
                        ref
                            .read(userDetailUpdateProvider.notifier)
                            .userDetailUpdate(
                              firstName: firstNameController.text.trim(),
                              lastName: lastNameController.text.trim(),
                              mobileNumber: phoneNumberController.text.trim(),
                              email: emailController.text.trim(),
                              uID: auth.user[0].userId,
                              token: auth.user[0].token,
                            );
                      } else {
                        final isValidSize =
                            await isImageSizeValid(image, 10 * 1024 * 1024);
                        if (isValidSize) {
                          ref
                              .read(userDetailUpdateProvider.notifier)
                              .userDetailUpdate(
                                  firstName: firstNameController.text.trim(),
                                  lastName: lastNameController.text.trim(),
                                  mobileNumber:
                                      phoneNumberController.text.trim(),
                                  email: emailController.text.trim(),
                                  uID: auth.user[0].userId,
                                  token: auth.user[0].token,
                                  profilePicture: image);
                        } else {
                          Toasts.showFormFailure(
                              'Image size is too large. Image size shouldn\'t be greater than 10MB.');
                        }
                      }
                    } else {
                      Toasts.showFormFailure(
                          'Please fill in all required fields');
                    }
                  },
                  text: userUpdate.isLoad ? 'please wait' : 'Save Changes'),
            ],
          ),
        ));
  }
}
