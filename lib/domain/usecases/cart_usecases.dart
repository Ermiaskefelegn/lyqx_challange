import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import '../../core/utils/failure.dart';
import '../entities/cart_item.dart';
import '../entities/product.dart';
import '../repositories/cart_repository.dart';

@injectable
class GetCartItemsUseCase {
  final CartRepository repository;

  GetCartItemsUseCase(this.repository);

  Future<Either<Failure, List<CartItem>>> call() {
    return repository.getCartItems();
  }
}

@injectable
class AddToCartUseCase {
  final CartRepository repository;

  AddToCartUseCase(this.repository);

  Future<Either<Failure, void>> call(Product product) {
    return repository.addToCart(product);
  }
}

@injectable
class RemoveFromCartUseCase {
  final CartRepository repository;

  RemoveFromCartUseCase(this.repository);

  Future<Either<Failure, void>> call(int productId) {
    return repository.removeFromCart(productId);
  }
}

@injectable
class UpdateCartQuantityUseCase {
  final CartRepository repository;

  UpdateCartQuantityUseCase(this.repository);

  Future<Either<Failure, void>> call(int productId, int quantity) {
    return repository.updateQuantity(productId, quantity);
  }
}
