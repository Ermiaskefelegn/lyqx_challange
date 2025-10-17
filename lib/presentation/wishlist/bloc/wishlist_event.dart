import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class WishlistEvent extends Equatable {
  const WishlistEvent();

  @override
  List<Object> get props => [];
}

class LoadWishlist extends WishlistEvent {}

class AddToWishlistEvent extends WishlistEvent {
  final Product product;

  const AddToWishlistEvent(this.product);

  @override
  List<Object> get props => [product];
}

class RemoveFromWishlistEvent extends WishlistEvent {
  final int productId;

  const RemoveFromWishlistEvent(this.productId);

  @override
  List<Object> get props => [productId];
}

class CheckWishlistStatus extends WishlistEvent {
  final int productId;

  const CheckWishlistStatus(this.productId);

  @override
  List<Object> get props => [productId];
}
