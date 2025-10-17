import 'package:dartz/dartz.dart';
import '../../core/utils/failure.dart';
import '../entities/cart_item.dart';
import '../entities/product.dart';

abstract class CartRepository {
  Future<Either<Failure, List<CartItem>>> getCartItems();
  Future<Either<Failure, void>> addToCart(Product product);
  Future<Either<Failure, void>> removeFromCart(int productId);
  Future<Either<Failure, void>> updateQuantity(int productId, int quantity);
  Future<Either<Failure, void>> clearCart();
}
