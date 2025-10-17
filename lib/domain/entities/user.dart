import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String token;
  final String username;

  const User({
    required this.token,
    required this.username,
  });

  @override
  List<Object> get props => [token, username];
}
