import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/utils/failure.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/local/wishlist_local_datasource.dart';
import '../models/product_model.dart';

@LazySingleton(as: WishlistRepository)
class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistLocalDataSource localDataSource;

  WishlistRepositoryImpl(this.localDataSource);

  @override
  Future<Either<Failure, List<Product>>> getWishlistItems() async {
    try {
      final items = await localDataSource.getWishlistItems();
      return Right(items);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> addToWishlist(Product product) async {
    try {
      final productModel = ProductModel(
        id: product.id,
        title: product.title,
        price: product.price,
        description: product.description,
        category: product.category,
        image: product.image,
        rating: product.rating,
      );
      await localDataSource.addToWishlist(productModel);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> removeFromWishlist(int productId) async {
    try {
      await localDataSource.removeFromWishlist(productId);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isInWishlist(int productId) async {
    try {
      final isInWishlist = await localDataSource.isInWishlist(productId);
      return Right(isInWishlist);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
