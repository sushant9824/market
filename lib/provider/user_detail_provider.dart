import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';

import '../model/auth_model/user.dart';
import '../model/user_detail_model/crud_state.dart';
import '../model/user_detail_model/user_detail.dart';
import '../model/user_detail_model/user_detail_state.dart';
import '../services/user_detail_services.dart';
import 'auth_provider.dart';

UserDetail userDetail = UserDetail(
    id: 0,
    firstName: '',
    lastName: '',
    fullName: '',
    mobileNumber: '',
    email: '',
    profilePictureUrl: '');

final userDetailsProvider =
    StateNotifierProvider<UserDetailProvider, UserDetailState>((ref) {
  final auth = ref.watch(loginProvider);
  return UserDetailProvider(
      UserDetailState(
          isError: false,
          isLoad: false,
          errorMessage: '',
          userDetail: userDetail),
      auth.user[0].token,
      auth.user[0].userId);
});

class UserDetailProvider extends StateNotifier<UserDetailState> {
  final String token;
  final int userId;

  UserDetailProvider(super.state, this.token, this.userId) {
    getUserDetails();
  }

  //get user details
  Future<void> getUserDetails<UserState>() async {
    state = state.copyWith(isLoad: true, isError: false, errorMessage: '');
    final res =
        await UserDetailService.getUserDetails(token: token, userId: userId);
    res.fold((l) {
      state = state.copyWith(isLoad: false, isError: true, errorMessage: l);
    }, (r) {
      state = state.copyWith(isLoad: false, isError: false, userDetail: r);
    });
  }
}

//------------------user profile update ------------------------

final userDetailUpdateProvider =
    StateNotifierProvider<UserDetailsUpdateProvider, CrudState>((ref) =>
        UserDetailsUpdateProvider(CrudState(
            errMessage: '', isError: false, isLoad: false, isSuccess: false)));

class UserDetailsUpdateProvider extends StateNotifier<CrudState> {
  UserDetailsUpdateProvider(super.state);

  Future<void> userDetailUpdate({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String email,
    required int uID,
    required String token,
    XFile? profilePicture,
  }) async {
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false);
    final res = await UserDetailService.userUpdate(
        firstName: firstName,
        lastName: lastName,
        mobileNumber: mobileNumber,
        email: email,
        uID: uID,
        token: token,
        profilePicture: profilePicture);
    res.fold(
        (l) => state = state.copyWith(
            isLoad: false, isError: true, isSuccess: false, errMessage: l),
        (r) => state = state.copyWith(
            isLoad: false, isError: false, isSuccess: r, errMessage: ''));
  }
}

//-----change password --------
final changePasswordProvider = StateNotifierProvider<PasswordChange, CrudState>(
    (ref) => PasswordChange(CrudState(
        isError: false, isLoad: false, isSuccess: false, errMessage: '')));

class PasswordChange extends StateNotifier<CrudState> {
  PasswordChange(super.state);

  Future<void> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    required int uID,
    required String token,
  }) async {
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false);
    final res = await UserDetailService.changePassword(
        oldPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
        uID: uID,
        token: token);
    res.fold(
        (l) => state = state.copyWith(
            isLoad: false, isError: true, isSuccess: false, errMessage: l),
        (r) => state = state.copyWith(
            isLoad: false, isError: false, isSuccess: r, errMessage: ''));
  }
}
