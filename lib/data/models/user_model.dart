import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.token,
    required super.username,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String username) {
    return UserModel(
      token: json['token'] as String,
      username: username,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'username': username,
    };
  }
}
