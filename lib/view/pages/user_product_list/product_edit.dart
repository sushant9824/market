import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:form_validation/form_validation.dart';
import 'package:market_app/constant/text_styles.dart';
import 'package:market_app/provider/product_provider.dart';

import '../../../constant/common widget/custom_button.dart';
import '../../../constant/common widget/custom_search_dropdown.dart';
import '../../../constant/common widget/custom_text_form.dart';
import '../../../constant/common widget/image_container.dart';
import '../../../constant/common widget/toast_alert.dart';
import '../../../model/product_model/product.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/autoValidate_provider.dart';
import '../../../provider/image_picker_provider.dart';

class ProductEdit extends ConsumerStatefulWidget {
  Product product;

  ProductEdit({required this.product});

  @override
  ConsumerState<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends ConsumerState<ProductEdit> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.product.title;
    brandController.text = widget.product.brand;
    selectedCondition = widget.product.conditions;
    selectedDeliveryOption = widget.product.delivery;
    deliveryChargeController.text = widget.product.deliveryCharge;
    selectedWarranty = widget.product.warranty;
    warrantyPeriodController.text = widget.product.warrantyPeriod;
    addressController.text = widget.product.address;
    selectedPrice = widget.product.negotiable;
    amountController.text = widget.product.price.toString();
    descriptionController.text = widget.product.description;
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(productUpdateProvider, (previous, next) {
      if (next.isError) {
        Toasts.showFormFailure(next.errMessage);
      } else if (next.isSuccess) {
        ref.invalidate(productByUidProvider);
        ref.invalidate(productShow);
        Navigator.of(context).pop();
        Toasts.showSuccess('Ads Updated Successfully !!');
      }
    });

    final updateProduct = ref.watch(productUpdateProvider);
    final image = ref.watch(imageProvider);
    final mode = ref.watch(autoValidateMode);
    final auth = ref.watch(loginProvider);
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit', style: TextStyles.headingStyle),
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
                  selectedItem: selectedCondition,
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
                  selectedItem: selectedDeliveryOption == true ? 'Yes' : 'No',
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
                  selectedItem: selectedWarranty == true ? 'Yes' : 'No',
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
                  selectedItem: selectedPrice == true ? 'Negotiable' : 'Fixed',
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
                      ? Image.network(widget.product.marketPictureUrl)
                      : Image.file(File(image.path), fit: BoxFit.fitWidth),
                ),
                CustomButton(
                    onPressed: () {
                      _formKey.currentState!.save();
                      FocusScope.of(context).unfocus();
                      if (_formKey.currentState!.validate()) {
                        if (image == null) {
                          ref
                              .read(productUpdateProvider.notifier)
                              .updateProducts(
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
                                  description:
                                      descriptionController.text.trim(),
                                  productId: widget.product.marketId,
                                  token: auth.user[0].token);
                        } else {
                          ref
                              .read(productUpdateProvider.notifier)
                              .updateProducts(
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
                                  description:
                                      descriptionController.text.trim(),
                                  productId: widget.product.marketId,
                                  token: auth.user[0].token,
                                  marketPicture: image);
                        }
                      } else {
                        ref.read(autoValidateMode.notifier).toggle();
                        Toasts.showFormFailure(
                            'Please fill in all required fields');
                      }
                    },
                    text: updateProduct.isLoad ? 'please wait' : 'Update Ad')
              ],
            )),
      ),
    );
  }
}
