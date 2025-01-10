import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../api/api.dart';
import '../model/auth_model/user.dart';

class AuthServices {
  static Dio dio = Dio();
  static Logger logger = Logger();

  // -----userRegister-----
  static Future<Either<String, bool>> userRegister({
    required String firstName,
    required String lastName,
    required String mobileNumber,
    required String email,
    required String password,
    required XFile profilePicture,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'firstName': firstName,
        'lastName': lastName,
        'mobileNumber': mobileNumber,
        'email': email,
        'password': password,
        'profilePicture': await MultipartFile.fromFile(profilePicture.path),
      });
      final response = await dio.post(
        Api.userRegister,
        data: formData,
      );

      // final response = await dio.post(Api.userRegister,
      // data: {
      //   'firstName' : firstName,
      //   'lastName' : lastName,
      //   'mobileNumber' : mobileNumber,
      //   'email' : email,
      //   'password' : password,
      //   'profilePicture' : profilePicture.path
      //     }
      // );
      // logger.d(response);
      return Right(true);
    } on DioError catch (err) {
      print(err);
      return Left('${err.response?.data['error']}');
    }
  }

  // -----userLogin-----
  static Future<Either<String, User>> userLogin({
    required String mobileNumber,
    required String password,
  }) async {
    try {
      final response = await dio.post(Api.userLogin, data: {
        'mobileNumber': mobileNumber,
        'password': password,
      });
      final user = User.fromJson(response.data);
      final box = Hive.box<User>('user');
      box.clear();
      box.add(user);
      // logger.d(response.data);
      return Right(user);
    } on DioException catch (err) {
      print(err);
      return Left('${err.response?.data['message']}');
    }
  }

  // ---- password reset -----
  static Future<Either<String, bool>> resetPassword({
    required String newPassword,
    required String confirmPassword,
    required int phoneNumber,
  }) async {
    try {
      await dio.post('${Api.resetPassword}/$phoneNumber/forget-password',
          data: {
            'newPassword': newPassword,
            'confirmPassword': confirmPassword
          });
      return Right(true);
    } on DioError catch (err) {
      print(err.message);
      return Left('${err.response?.data['message']}');
    }
  }
}
