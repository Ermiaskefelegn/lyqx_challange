import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> saveUser(UserModel user);
  Future<UserModel?> getUser();
  Future<void> clearUser();
}

@LazySingleton(as: AuthLocalDataSource)
class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> saveUser(UserModel user) async {
    await sharedPreferences.setString(AppConstants.tokenKey, user.token);
    await sharedPreferences.setString(AppConstants.usernameKey, user.username);
  }

  @override
  Future<UserModel?> getUser() async {
    final token = sharedPreferences.getString(AppConstants.tokenKey);
    final username = sharedPreferences.getString(AppConstants.usernameKey);

    if (token != null && username != null) {
      return UserModel(token: token, username: username);
    }
    return null;
  }

  @override
  Future<void> clearUser() async {
    await sharedPreferences.remove(AppConstants.tokenKey);
    await sharedPreferences.remove(AppConstants.usernameKey);
  }
}
