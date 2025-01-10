import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validation/form_validation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_app/constant/common%20widget/custom_text_form.dart';
import 'package:market_app/constant/text_styles.dart';
import 'package:market_app/provider/auth_provider.dart';
import 'package:market_app/provider/autoValidate_provider.dart';

import '../../../constant/common widget/custom_button.dart';
import '../../../constant/common widget/custom_search_dropdown.dart';
import '../../../constant/common widget/image_container.dart';
import '../../../constant/common widget/toast_alert.dart';
import '../../../provider/image_picker_provider.dart';
import '../../../provider/product_provider.dart';

class ProductCreate extends ConsumerStatefulWidget {
  const ProductCreate({super.key});

  @override
  ConsumerState<ProductCreate> createState() => _ProductCreateState();
}

class _ProductCreateState extends ConsumerState<ProductCreate> {
  TextEditingController titleController = TextEditingController();
  TextEditingController brandController = TextEditingController();
  TextEditingController deliveryChargeController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController warrantyPeriodController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedCondition;
  bool? selectedDeliveryOption;
  bool? selectedPrice;
  bool? selectedWarranty;

  //**check image size */
  Future<bool> isImageSizeValid(XFile imageXFile, int maxSizeInBytes) async {
    final imageFile = File(imageXFile.path); // Convert XFile to File
    final fileLength = await imageFile.length();
    return fileLength <= maxSizeInBytes;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(productAddProvider, (previous, next) {
      if (next.isError) {
        Toasts.showFormFailure(next.errMessage);
      } else if (next.isSuccess) {
        Navigator.of(context).pop();
        ref.invalidate(productShow);
        ref.invalidate(productByUidProvider);
        Toasts.showSuccess('Ad Posted Successfully !!');
      }
    });
    final addProduct = ref.watch(productAddProvider);
    final image = ref.watch(imageProvider);
    final mode = ref.watch(autoValidateMode);
    final auth = ref.watch(loginProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Ad', style: TextStyles.headingStyle),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
        child: Form(
            key: _formKey,
            autovalidateMode: mode,
            child: Column(
              children: [
                CustomTextForm(
                    controller: titleController,
                    labelText: 'Ad Title',
                    hintText: 'Ad Title',
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      final validator =
                          Validator(validators: [const RequiredValidator()]);
                      return validator.validate(
                        label: 'This field',
                        value: val,
                      );
                    }),
                CustomTextForm(
                    controller: brandController,
                    labelText: 'Brand',
                    hintText: 'Brand',
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      final validator =
                          Validator(validators: [const RequiredValidator()]);
                      return validator.validate(
                        label: 'This field',
                        value: val,
                      );
                    }),
                CustomSearchDropDown(
                  labelText: 'Conditions',
                  hintText: 'Conditions',
                  items: const [
                    'Brand New',
                    'Like New',
                    'Used',
                    'Not Working',
                  ],
                  validator: (item) {
                    if (item == null) {
                      return "This field is required";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (condition) {
                    setState(() {
                      selectedCondition = condition;
                    });
                  },
                ),
                CustomSearchDropDown(
                  labelText: 'Delivery',
                  hintText: 'Delivery',
                  items: const [
                    'Yes',
                    'No',
                  ],
                  validator: (item) {
                    if (item == null) {
                      return "This field is required";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (delivery) {
                    setState(() {
                      selectedDeliveryOption = delivery == 'Yes' ? true : false;
                      if (selectedDeliveryOption == false) {
                        deliveryChargeController.clear();
                      }
                    });
                  },
                ),
                if (selectedDeliveryOption != false)
                  CustomTextForm(
                      controller: deliveryChargeController,
                      labelText: 'Delivery Charge',
                      hintText: 'Delivery Charge',
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        final validator =
                            Validator(validators: [const RequiredValidator()]);
                        return validator.validate(
                          label: 'This field',
                          value: val,
                        );
                      }),
                CustomSearchDropDown(
                  labelText: 'Warranty',
                  hintText: 'Warranty',
                  items: const [
                    'Yes',
                    'No',
                  ],
                  validator: (item) {
                    if (item == null) {
                      return "This field is required";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (warranty) {
                    setState(() {
                      selectedWarranty = warranty == 'Yes' ? true : false;
                      if (selectedWarranty == false) {
                        warrantyPeriodController.clear();
                      }
                    });
                  },
                ),
                if (selectedWarranty != false)
                  CustomTextForm(
                      controller: warrantyPeriodController,
                      labelText: 'Warrenty Period',
                      hintText: 'Warrenty Period',
                      keyboardType: TextInputType.text,
                      validator: (val) {
                        final validator =
                            Validator(validators: [const RequiredValidator()]);
                        return validator.validate(
                          label: 'This field',
                          value: val,
                        );
                      }),
                CustomTextForm(
                    controller: addressController,
                    labelText: 'Address',
                    hintText: 'Address',
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      final validator =
                          Validator(validators: [const RequiredValidator()]);
                      return validator.validate(
                        label: 'This field',
                        value: val,
                      );
                    }),
                CustomSearchDropDown(
                  labelText: 'Price',
                  hintText: 'Price',
                  items: const [
                    'Negotiable',
                    'Fixed',
                  ],
                  validator: (item) {
                    if (item == null) {
                      return "This field is required";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (price) {
                    setState(() {
                      selectedPrice = price == 'Negotiable' ? true : false;
                    });
                  },
                ),
                CustomTextForm(
                    controller: amountController,
                    labelText: 'Amount',
                    hintText: 'Amount',
                    keyboardType: TextInputType.number,
                    validator: (val) {
                      final validator =
                          Validator(validators: [const RequiredValidator()]);
                      return validator.validate(
                        label: 'This field',
                        value: val,
                      );
                    }),
                CustomTextForm(
                    controller: descriptionController,
                    labelText: 'Description',
                    hintText: 'Description',
                    maxLines: 4,
                    keyboardType: TextInputType.text,
                    validator: (val) {
                      final validator =
                          Validator(validators: [const RequiredValidator()]);
                      return validator.validate(
                        label: 'This field',
                        value: val,
                      );
                    }),
                ImageContainer(
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ref.read(imageProvider.notifier).imagePick(true);
                        },
                        child: Text('Camera', style: TextStyles.hintStyle)),
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ref.read(imageProvider.notifier).imagePick(false);
                        },
                        child: Text('Gallery', style: TextStyles.hintStyle)),
                  ],
                  child: image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_photo_alternate_outlined,
                              size: 60.r,
                            ),
                            Text(
                              'Upload an image',
                              style: TextStyles.hintStyle,
                            )
                          ],
                        )
                      : Image.file(File(image.path), fit: BoxFit.fitWidth),
                ),
                CustomButton(
                    onPressed: () async {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        if (image == null) {
                          Toasts.showFormFailure('Image is required !!');
                        } else {
                          final isValidSize =
                              await isImageSizeValid(image, 5 * 1024 * 1024);
                          if (isValidSize) {
                            ref.read(productAddProvider.notifier).addProdcut(
                                title: titleController.text.trim(),
                                brand: brandController.text.trim(),
                                conditions: selectedCondition!,
                                delivery: selectedDeliveryOption!,
                                deliveryCharge:
                                    deliveryChargeController.text.trim(),
                                warranty: selectedWarranty!,
                                warrantyPeriod:
                                    warrantyPeriodController.text.trim(),
                                address: addressController.text.trim(),
                                negotiable: selectedPrice!,
                                price: amountController.text.trim(),
                                description: descriptionController.text.trim(),
                                marketPicture: image,
                                uID: auth.user[0].userId,
                                token: auth.user[0].token);
                          } else {
                            Toasts.showFormFailure(
                                'Image size is too large. Image size shouldn\'t be greater than 5MB.');
                          }
                        }
                      } else {
                        ref.read(autoValidateMode.notifier).toggle();
                        Toasts.showFormFailure(
                            'Please fill in all required fields');
                      }
                    },
                    text: addProduct.isLoad ? 'please wait' : 'Post Ad')
              ],
            )),
      ),
    );
  }
}
