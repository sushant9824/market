import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import '../api/api.dart';
import '../model/user_detail_model/user_detail.dart';

class UserDetailService {
  static Dio dio = Dio();

  //get user details
  static Future<Either<String, UserDetail>> getUserDetails(
      {required String token, required int userId}) async {
    try {
      final res = await dio.get('${Api.getUserDetails}/$userId',
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      final data = UserDetail.fromJson(res.data);
      return Right(data);
    } on DioError catch (err) {
      print(err.message);
      return Left('${err.response}');
    }
  }

  //user detail update
  static Future<Either<String, bool>> userUpdate({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String email,
    required int uID,
    required String token,
    XFile? profilePicture,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'mobileNumber': mobileNumber,
        'email': email,
      });

      if (profilePicture != null) {
        formData.files.add(MapEntry(
          'profilePicture',
          await MultipartFile.fromFile(profilePicture.path),
        ));
      }

      final res = await dio.put('${Api.userDetailUpdate}/$uID',
          data: formData,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));

      return Right(true);
    } on DioError catch (err) {
      print(err);
      return Left('${err.message}');
    }
  }

  //----change password--------
  static Future<Either<String, bool>> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
    required int uID,
    required String token,
  }) async {
    try {
      final res = await dio.post('${Api.changePassword}/$uID/change-password',
          data: {
            'oldPassword': oldPassword,
            'newPassword': newPassword,
            'confirmPassword': confirmPassword
          },
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      return Right(true);
    } on DioError catch (err) {
      print(err);
      return Left('${err.response?.data['message']}');
    }
  }
}
