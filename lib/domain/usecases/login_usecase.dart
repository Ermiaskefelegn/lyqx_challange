import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/utils/failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<Failure, User>> call(String username, String password) {
    return repository.login(username, password);
  }
}
