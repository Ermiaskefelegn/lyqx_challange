import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/utils/failure.dart';
import '../entities/product.dart';
import '../repositories/product_repository.dart';

@injectable
class GetProductsUseCase {
  final ProductRepository repository;

  GetProductsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call({int? limit, int? offset}) {
    return repository.getProducts(limit: limit, offset: offset);
  }
}
