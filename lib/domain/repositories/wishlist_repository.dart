import 'package:dartz/dartz.dart';
import '../../core/utils/failure.dart';
import '../entities/product.dart';

abstract class WishlistRepository {
  Future<Either<Failure, List<Product>>> getWishlistItems();
  Future<Either<Failure, void>> addToWishlist(Product product);
  Future<Either<Failure, void>> removeFromWishlist(int productId);
  Future<Either<Failure, bool>> isInWishlist(int productId);
}
