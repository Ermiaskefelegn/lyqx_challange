import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/cart_item_model.dart';
import '../../models/product_model.dart';

abstract class CartLocalDataSource {
  Future<List<CartItemModel>> getCartItems();
  Future<void> saveCartItems(List<CartItemModel> items);
  Future<void> addToCart(ProductModel product);
  Future<void> removeFromCart(int productId);
  Future<void> updateQuantity(int productId, int quantity);
  Future<void> clearCart();
}

@LazySingleton(as: CartLocalDataSource)
class CartLocalDataSourceImpl implements CartLocalDataSource {
  final SharedPreferences sharedPreferences;

  CartLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<CartItemModel>> getCartItems() async {
    final String? cartJson = sharedPreferences.getString(AppConstants.cartKey);
    if (cartJson == null) return [];

    final List<dynamic> decoded = jsonDecode(cartJson);
    return decoded.map((item) => CartItemModel.fromJson(item)).toList();
  }

  @override
  Future<void> saveCartItems(List<CartItemModel> items) async {
    final List<Map<String, dynamic>> jsonList = items.map((item) => item.toJson()).toList();
    await sharedPreferences.setString(AppConstants.cartKey, jsonEncode(jsonList));
  }

  @override
  Future<void> addToCart(ProductModel product) async {
    final items = await getCartItems();
    final existingIndex = items.indexWhere((item) => item.product.id == product.id);

    if (existingIndex >= 0) {
      items[existingIndex] = CartItemModel(product: product, quantity: items[existingIndex].quantity + 1);
    } else {
      items.add(CartItemModel(product: product, quantity: 1));
    }

    await saveCartItems(items);
  }

  @override
  Future<void> removeFromCart(int productId) async {
    final items = await getCartItems();
    items.removeWhere((item) => item.product.id == productId);
    await saveCartItems(items);
  }

  @override
  Future<void> updateQuantity(int productId, int quantity) async {
    final items = await getCartItems();
    final index = items.indexWhere((item) => item.product.id == productId);

    if (index >= 0) {
      if (quantity <= 0) {
        items.removeAt(index);
      } else {
        items[index] = CartItemModel(product: items[index].product, quantity: quantity);
      }
      await saveCartItems(items);
    }
  }

  @override
  Future<void> clearCart() async {
    await sharedPreferences.remove(AppConstants.cartKey);
  }
}
