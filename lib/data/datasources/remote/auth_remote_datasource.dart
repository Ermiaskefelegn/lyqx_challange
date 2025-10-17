import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:lyqx_challange/core/network/exceptions.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String username, String password);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient client;

  AuthRemoteDataSourceImpl(this.client);

  @override
  Future<UserModel> login(String username, String password) async {
    try {
      final response = await client.post(
        ApiConstants.loginEndpoint,
        data: {'username': username, 'password': password},
      );

      if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
        log(response.data.toString());
        return UserModel.fromJson(response.data, username);
      } else {
        throw NetworkException.custom(
          message: 'Login failed with status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw parseDioError(e);
    }
  }
}
