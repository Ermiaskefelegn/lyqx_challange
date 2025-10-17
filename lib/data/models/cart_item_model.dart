import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import 'product_model.dart';

class CartItemModel extends CartItem {
  const CartItemModel({
    required super.product,
    required super.quantity,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      product: ProductModel.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': (product as ProductModel).toJson(),
      'quantity': quantity,
    };
  }

  factory CartItemModel.fromEntity(CartItem item) {
    return CartItemModel(
      product: item.product,
      quantity: item.quantity,
    );
  }
}
