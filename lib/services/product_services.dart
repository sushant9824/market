import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_app/model/product_model/product.dart';
import '../api/api.dart';

class ProductService {
  static Dio dio = Dio();

  // add products
  static Future<Either<String, bool>> addProducts({
    required String title,
    required String brand,
    required String conditions,
    required bool delivery,
    required String deliveryCharge,
    required bool warranty,
    required String warrantyPeriod,
    required String address,
    required bool negotiable,
    required String price,
    required String description,
    required XFile marketPicture,
    required int uID,
    required String token,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'title': title,
        'brand': brand,
        'conditions': conditions,
        'delivery': delivery,
        'deliveryCharge': deliveryCharge,
        'warranty': warranty,
        'warrantyPeriod': warrantyPeriod,
        'address': address,
        'negotiable': negotiable,
        'price': price,
        'description': description,
        'marketPicture': await MultipartFile.fromFile(marketPicture.path),
      });
      final response = await dio.post('${Api.createProducts}/$uID/markets',
          data: formData,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      return Right(true);
    } on DioError catch (err) {
      print(err);
      return Left('${err.response?.data['message']}');
    }
  }

  //get products by userId
  static Future<Either<String, List<Product>>> getProductByUid({
    required String token,
    required int uID,
  }) async {
    try {
      final res = await dio.get('${Api.getProductsByUid}/$uID/markets',
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      final data =
          (res.data['Market'] as List).map((e) => Product.fromJson(e)).toList();
      return Right(data);
    } on DioError catch (err) {
      print(err);
      return Left('${err.response?.data['message']}');
    }
  }

  //update products---------
  static Future<Either<String, bool>> updateProduct({
    required String title,
    required String brand,
    required String conditions,
    required bool delivery,
    required String deliveryCharge,
    required bool warranty,
    required String warrantyPeriod,
    required String address,
    required bool negotiable,
    required String price,
    required String description,
    XFile? marketPicture,
    required int productId,
    required String token,
  }) async {
    try {
      FormData formData = FormData.fromMap({
        'title': title,
        'brand': brand,
        'conditions': conditions,
        'delivery': delivery,
        'deliveryCharge': deliveryCharge,
        'warranty': warranty,
        'warrantyPeriod': warrantyPeriod,
        'address': address,
        'negotiable': negotiable,
        'price': price,
        'description': description,
      });
      if (marketPicture != null) {
        formData.files.add(MapEntry(
          'marketPicture',
          await MultipartFile.fromFile(marketPicture.path),
        ));
      }
      final res = await dio.put('${Api.productUpdate}/$productId',
          data: formData,
          options: Options(headers: {
            HttpHeaders.authorizationHeader: 'Bearer $token',
          }));
      return Right(true);
    } on DioException catch (err) {
      print(err);
      return Left('${err.response?.data['message']}');
    }
  }
}
