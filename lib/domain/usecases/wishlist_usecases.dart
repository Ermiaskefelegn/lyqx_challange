import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/utils/failure.dart';
import '../entities/product.dart';
import '../repositories/wishlist_repository.dart';

@injectable
class GetWishlistItemsUseCase {
  final WishlistRepository repository;

  GetWishlistItemsUseCase(this.repository);

  Future<Either<Failure, List<Product>>> call() {
    return repository.getWishlistItems();
  }
}

@injectable
class AddToWishlistUseCase {
  final WishlistRepository repository;

  AddToWishlistUseCase(this.repository);

  Future<Either<Failure, void>> call(Product product) {
    return repository.addToWishlist(product);
  }
}

@injectable
class RemoveFromWishlistUseCase {
  final WishlistRepository repository;

  RemoveFromWishlistUseCase(this.repository);

  Future<Either<Failure, void>> call(int productId) {
    return repository.removeFromWishlist(productId);
  }
}

@injectable
class IsInWishlistUseCase {
  final WishlistRepository repository;

  IsInWishlistUseCase(this.repository);

  Future<Either<Failure, bool>> call(int productId) {
    return repository.isInWishlist(productId);
  }
}
