import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:lyqx_challange/core/network/exceptions.dart';
import '../../core/utils/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/remote/product_remote_datasource.dart';

@LazySingleton(as: ProductRepository)
class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts({int? limit, int? offset}) async {
    try {
      final products = await remoteDataSource.getProducts(limit: limit, offset: offset);
      return Right(products);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Product>> getProductById(int id) async {
    try {
      final product = await remoteDataSource.getProductById(id);
      return Right(product);
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
