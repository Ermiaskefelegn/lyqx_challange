import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:lyqx_challange/core/network/dio_interceptor.dart';
import 'package:lyqx_challange/core/services/secure_storage_service.dart';
import '../constants/api_constants.dart';

@lazySingleton
class DioClient {
  late final Dio _dio;

  DioClient(SecureStorageService secureStorageService) {
    _dio =
        Dio(
            BaseOptions(
              baseUrl: ApiConstants.baseUrl,
              connectTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          )
          ..interceptors.addAll([
            ApiInterceptor(secureStorageService),
            LogInterceptor(requestBody: true, responseBody: true),
          ]);
  }

  Dio get dio => _dio;

  Future<Response> get(String path, {Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.get(path, queryParameters: queryParameters, options: options);
  }

  Future<Response> post(String path, {dynamic data, Map<String, dynamic>? queryParameters, Options? options}) async {
    return await _dio.post(path, data: data, queryParameters: queryParameters, options: options);
  }

  Future<Response> put(String path, {Map<String, dynamic>? data, Options? options}) async {
    return await _dio.put(path, data: data, options: options);
  }

  Future<Response> delete(String path, {Map<String, dynamic>? data, Options? options}) async {
    return await _dio.delete(path, data: data, options: options);
  }

  Future<Response> patch(String path, {Map<String, dynamic>? data, Options? options}) async {
    return await _dio.patch(path, data: data, options: options);
  }
}
