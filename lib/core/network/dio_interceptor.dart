import 'package:dio/dio.dart';
import 'package:lyqx_challange/core/network/exceptions.dart';
import 'package:lyqx_challange/core/services/secure_storage_service.dart';

class ApiInterceptor extends Interceptor {
  final SecureStorageService secureStorageService;

  ApiInterceptor(this.secureStorageService);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    options.headers['Content-Type'] = 'application/json';

    final accessToken = await secureStorageService.read(key: 'access_token');
    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final networkException = NetworkException.fromDioError(err);

    handler.reject(
      DioException(requestOptions: err.requestOptions, response: err.response, type: err.type, error: networkException),
    );
  }
}
