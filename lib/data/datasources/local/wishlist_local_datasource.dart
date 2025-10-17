import 'dart:convert';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../models/product_model.dart';

abstract class WishlistLocalDataSource {
  Future<List<ProductModel>> getWishlistItems();
  Future<void> saveWishlistItems(List<ProductModel> items);
  Future<void> addToWishlist(ProductModel product);
  Future<void> removeFromWishlist(int productId);
  Future<bool> isInWishlist(int productId);
}

@LazySingleton(as: WishlistLocalDataSource)
class WishlistLocalDataSourceImpl implements WishlistLocalDataSource {
  final SharedPreferences sharedPreferences;

  WishlistLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<List<ProductModel>> getWishlistItems() async {
    final String? wishlistJson = sharedPreferences.getString(AppConstants.wishlistKey);
    if (wishlistJson == null) return [];

    final List<dynamic> decoded = jsonDecode(wishlistJson);
    return decoded.map((item) => ProductModel.fromJson(item)).toList();
  }

  @override
  Future<void> saveWishlistItems(List<ProductModel> items) async {
    final List<Map<String, dynamic>> jsonList = items.map((item) => item.toJson()).toList();
    await sharedPreferences.setString(AppConstants.wishlistKey, jsonEncode(jsonList));
  }

  @override
  Future<void> addToWishlist(ProductModel product) async {
    final items = await getWishlistItems();
    if (!items.any((item) => item.id == product.id)) {
      items.add(product);
      await saveWishlistItems(items);
    }
  }

  @override
  Future<void> removeFromWishlist(int productId) async {
    final items = await getWishlistItems();
    items.removeWhere((item) => item.id == productId);
    await saveWishlistItems(items);
  }

  @override
  Future<bool> isInWishlist(int productId) async {
    final items = await getWishlistItems();
    return items.any((item) => item.id == productId);
  }
}
