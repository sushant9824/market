import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../api/api.dart';
import '../model/product_model/crud_state.dart';
import '../model/product_model/product.dart';
import '../model/product_model/product_state.dart';
import '../services/product_services.dart';
import 'auth_provider.dart';

final productAddProvider = StateNotifierProvider<ProductProvider, CrudState>(
    (ref) => ProductProvider(CrudState(
        errMessage: '', isError: false, isLoad: false, isSuccess: false)));

final productUpdateProvider = StateNotifierProvider<ProductProvider, CrudState>(
    (ref) => ProductProvider(CrudState(
        errMessage: '', isError: false, isLoad: false, isSuccess: false)));

class ProductProvider extends StateNotifier<CrudState> {
  ProductProvider(super.state);

  //create post ad
  Future<void> addProdcut({
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
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false);
    final res = await ProductService.addProducts(
        title: title,
        brand: brand,
        conditions: conditions,
        delivery: delivery,
        deliveryCharge: deliveryCharge,
        warranty: warranty,
        warrantyPeriod: warrantyPeriod,
        address: address,
        negotiable: negotiable,
        price: price,
        description: description,
        marketPicture: marketPicture,
        uID: uID,
        token: token);

    res.fold(
      (l) => state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l),
      (r) => state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errMessage: ''),
    );
  }

  //update Products-----------------------
  Future<void> updateProducts({
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
    state = state.copyWith(isLoad: true, isError: false, isSuccess: false);
    final response = await ProductService.updateProduct(
        title: title,
        brand: brand,
        conditions: conditions,
        delivery: delivery,
        deliveryCharge: deliveryCharge,
        warranty: warranty,
        warrantyPeriod: warrantyPeriod,
        address: address,
        negotiable: negotiable,
        price: price,
        description: description,
        productId: productId,
        token: token,
        marketPicture: marketPicture);
    response.fold(
      (l) => state = state.copyWith(
          isLoad: false, isError: true, isSuccess: false, errMessage: l),
      (r) => state = state.copyWith(
          isLoad: false, isError: false, isSuccess: r, errMessage: ''),
    );
  }
}

//get products by uid
final productByUidProvider =
    StateNotifierProvider<ProductByUidProvider, ProductState>((ref) {
  final auth = ref.watch(loginProvider);
  return ProductByUidProvider(
      ProductState(
          isLoad: false, isError: false, errorMessage: '', productList: []),
      auth.user[0].token,
      auth.user[0].userId);
});

class ProductByUidProvider extends StateNotifier<ProductState> {
  final String token;
  final int uID;
  ProductByUidProvider(super.state, this.token, this.uID) {
    getProductByUID();
  }

  Future<void> getProductByUID() async {
    state = state.copyWith(isLoad: true, isError: false);
    final res = await ProductService.getProductByUid(token: token, uID: uID);
    res.fold(
        (l) => state =
            state.copyWith(isLoad: false, isError: true, errorMessage: l),
        (r) => state = state.copyWith(
            isLoad: false, isError: false, errorMessage: '', productList: r));
  }
}

//get all products homepage----------------------------------
final productShow = FutureProvider((ref) => Products.getAllProdcuts());

class Products {
  static Dio dio = Dio();
  //**get all products */
  static Future<List<Product>> getAllProdcuts() async {
    try {
      final res = await dio.get(Api.getAllProdcts);
      final data = (res.data['Markets'] as List)
          .map((e) => Product.fromJson(e))
          .toList();
      return data;
    } on DioError catch (err) {
      print(err);
      throw '${err.message}';
    }
  }
}
