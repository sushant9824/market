import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../colors.dart';
import '../text_styles.dart';

class CustomSearchDropDown<T> extends StatelessWidget {
  final String labelText;
  final String hintText;
  void Function(T?)? onChanged;
  String Function(T)? itemAsString;
  Future<List<T>> Function(String)? asyncItems;
  String? Function(T?)? validator;
  bool enabled;
  List<T>? items;
  Key? key;
  bool showSearchBox;
  T? selectedItem;

  CustomSearchDropDown(
      {required this.labelText,
      required this.hintText,
      this.asyncItems,
      this.onChanged,
      this.itemAsString,
      this.validator,
      this.enabled = true,
      this.items,
      this.showSearchBox = false,
      this.selectedItem,
      this.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 21.r),
      child: DropdownSearch<T>(
        selectedItem: selectedItem,
        key: key,
        popupProps: PopupProps.modalBottomSheet(
          fit: FlexFit.loose,
          scrollbarProps: const ScrollbarProps(thumbColor: primaryColor),
          modalBottomSheetProps: ModalBottomSheetProps(
              shape: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.transparent),
                  borderRadius: BorderRadius.circular(12.0))),
        ),
        enabled: enabled,
        autoValidateMode: AutovalidateMode.onUserInteraction,
        dropdownDecoratorProps: DropDownDecoratorProps(
            baseStyle: TextStyles.textFieldStyle,
            dropdownSearchDecoration: InputDecoration(
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: primaryColor)),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade400)),
              errorStyle: TextStyle(height: 2),
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
              labelText: labelText,
              hintText: hintText,
              labelStyle: TextStyles.labelTextStyle,
              hintStyle: TextStyles.textFieldStyle,
            )),
        asyncItems: asyncItems,
        onChanged: onChanged,
        itemAsString: itemAsString,
        validator: validator,
        items: items!,
      ),
    );
  }
}
