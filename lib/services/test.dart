// String baseURL = “https://api-hr.theeliteexped.com/api/”;
import 'dart:developer';

import 'package:dio/dio.dart';

class API {
  factory API() => instance;
  static API instance = API._();
  API._() {
    _dio.interceptors.add(InterceptorsWrapper(onRequest: (options, handler) {
      return handler.next(options);
    }, onResponse: (response, handler) {
      return handler.resolve(response);
    }, onError: (DioError e, handler) async {
      if (e.response == null) {
        return handler.reject(e);
      } else if (e.response!.statusCode == 403) {
        var refresh = await refreshTokens();
        if (refresh) {
          final response = await _dio.fetch(e.requestOptions.copyWith(
            headers: getOptions(true)!.headers,
          ));
          return handler.resolve(response);
        } else {
          navKey.currentState!
              .pushNamedAndRemoveUntil(“/login”, ((route) => false));
        }
      }
      // CustomSnackbar.showSnackBar(
      //   message: “Error occured!“,
      //   backgroundColor: Colors.red,
      // );
      return handler.resolve(e.response!);
    }));
  }
  final _dio = Dio(
    BaseOptions(
      baseUrl: baseURL,
    ),
  );
  Options? getOptions(bool useToken) {
    if (useToken) {
      log(accessToken.toString());
      return Options(headers: {“Authorization”: “JWT $accessToken”});
    }
    return null;
  }
  // Get Method
  Future<Response> get(
    String path, {
    bool useToken = false,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    log(_dio.options.baseUrl + path);
    Response response = await _dio.get(
      path,
      queryParameters: queryParameters,
      options: getOptions(useToken),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }
  // Post Method
  Future<Response> post(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    bool useToken = false,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    log(_dio.options.baseUrl + path);
    log(data.toString());
    Response response = await _dio.post(
      path,
      data: data,
      queryParameters: queryParameters,
      options: getOptions(useToken),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }
  // Put Method
  Future<Response> put(
    String path, {
    dynamic data,
    bool useToken = false,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    log(_dio.options.baseUrl + path);
    log(data.toString());
    Response response = await _dio.put(
      path,
      data: data,
      queryParameters: queryParameters,
      options: getOptions(useToken),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }
  // Patch Method
  Future<Response> patch(
    String path, {
    dynamic data,
    bool useToken = false,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onSendProgress,
    void Function(int, int)? onReceiveProgress,
  }) async {
    log(_dio.options.baseUrl + path);
    log(data.toString());
    Response response = await _dio.patch(
      path,
      data: data,
      queryParameters: queryParameters,
      options: getOptions(useToken),
      cancelToken: cancelToken,
      onSendProgress: onSendProgress,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }
  // Delete Method
  Future<Response> delete(
    String path, {
    dynamic data,
    bool useToken = false,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    log(_dio.options.baseUrl + path);
    log(data.toString());
    Response response = await _dio.delete(
      path,
      data: data,
      queryParameters: queryParameters,
      options: getOptions(useToken),
      cancelToken: cancelToken,
    );
    return response;
  }
  // Download Method
  Future<Response> download(
    String urlPath,
    String savePath, {
    dynamic data,
    bool useToken = false,
    Map<String, dynamic>? queryParameters,
    CancelToken? cancelToken,
    void Function(int, int)? onReceiveProgress,
  }) async {
    Response response = await _dio.download(
      urlPath,
      savePath,
      data: data,
      queryParameters: queryParameters,
      options: getOptions(useToken),
      cancelToken: cancelToken,
      onReceiveProgress: onReceiveProgress,
    );
    return response;
  }
}