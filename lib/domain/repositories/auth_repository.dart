import 'package:dartz/dartz.dart';
import '../../core/utils/failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String username, String password);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getStoredUser();
}
