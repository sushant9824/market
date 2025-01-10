import 'user_detail.dart';

class UserDetailState {
  final bool isLoad;
  final bool isError;
  final String errorMessage;
  final UserDetail userDetail;

  UserDetailState({
    required this.isLoad,
    required this.isError,
    required this.errorMessage,
    required this.userDetail,
  });

  UserDetailState copyWith({
    bool? isLoad,
    bool? isError,
    String? errorMessage,
    UserDetail? userDetail,
  }) {
    return UserDetailState(
        isLoad: isLoad ?? this.isLoad,
        isError: isError ?? this.isError,
        errorMessage: errorMessage ?? this.errorMessage,
        userDetail: userDetail ?? this.userDetail);
  }
}
