import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:lyqx_challange/core/network/exceptions.dart';
import 'package:lyqx_challange/core/services/secure_storage_service.dart';
import 'package:lyqx_challange/core/di/injection.dart';
import '../../core/utils/failure.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/local/auth_local_datasource.dart';
import '../datasources/remote/auth_remote_datasource.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, User>> login(String username, String password) async {
    try {
      final user = await remoteDataSource.login(username, password);
      await localDataSource.saveUser(user);
      await getIt<SecureStorageService>().write(key: 'access_token', value: user.token);
      return Right(user);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localDataSource.clearUser();
      await getIt<SecureStorageService>().delete(key: 'access_token');
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User?>> getStoredUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
