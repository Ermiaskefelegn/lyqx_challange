import 'package:dartz/dartz.dart';
import '../../core/utils/failure.dart';
import '../entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts({int? limit, int? offset});
  Future<Either<Failure, Product>> getProductById(int id);
}
