import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object> get props => [];
}

class LoadCart extends CartEvent {}

class AddToCartEvent extends CartEvent {
  final Product product;

  const AddToCartEvent(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveFromCartEvent extends CartEvent {
  final int productId;

  const RemoveFromCartEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class UpdateCartQuantityEvent extends CartEvent {
  final int productId;
  final int quantity;

  const UpdateCartQuantityEvent(this.productId, this.quantity);

  @override
  List<Object> get props => [productId, quantity];
}
