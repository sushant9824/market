import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_app/main.dart';
import 'package:market_app/model/auth_model/auth_state.dart';
import '../model/auth_model/user.dart';
import '../services/auth_services.dart';

//**login provider */
final loginProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) =>
    AuthProvider(AuthState(
        errMessage: '',
        isError: false,
        isLoad: false,
        isSuccess: false,
        user: ref.watch(box))));

//**register provider */
final registerProvider = StateNotifierProvider<AuthProvider, AuthState>((ref) =>
    AuthProvider(AuthState(
        errMessage: '',
        isError: false,
        isLoad: false,
        isSuccess: false,
        user: ref.watch(box))));

class AuthProvider extends StateNotifier<AuthState> {
  AuthProvider(super.state);

  //-----user Registration------
  Future<void> userRegister<AuthState>({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String email,
    required String password,
    required XFile profilePicture,
  }) async {
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false);
    final res = await AuthServices.userRegister(
        firstName: firstName,
        lastName: lastName,
        mobileNumber: mobileNumber,
        email: email,
        password: password,
        profilePicture: profilePicture);
    res.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errMessage: '');
    });
  }

  //-----user Login------
  Future<void> userLogin<AuthState>({
    required String mobileNumber,
    required String password,
  }) async {
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false);
    final res = await AuthServices.userLogin(
        mobileNumber: mobileNumber, password: password);
    res.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false,
          isError: false,
          isSuccess: true,
          errMessage: '',
          user: [r]);
    });
  }

  //user logout
  Future<String> userLogOut() async {
    final box = Hive.box<User>('user');
    box.clear();
    state = state.copyWith(user: []);
    return 'success';
  }

  // ---------------- reset password -----------------
  Future<void> resetPassword<AuthState>({
    required String newPassword,
    required String confirmPassword,
    required int phoneNumber,
  }) async {
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false);
    final res = await AuthServices.resetPassword(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        phoneNumber: phoneNumber);
    res.fold((l) {
      state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l);
    }, (r) {
      state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errMessage: '');
    });
  }
}
