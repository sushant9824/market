import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final autoValidateMode =
    StateNotifierProvider.autoDispose<AutoValidate, AutovalidateMode>(
        (ref) => AutoValidate(AutovalidateMode.disabled));

class AutoValidate extends StateNotifier<AutovalidateMode> {
  AutoValidate(super.state);

  void toggle() {
    state = AutovalidateMode.onUserInteraction;
  }
// void autoValidateDisable(){
//   state = AutovalidateMode.disabled;
// }
}
