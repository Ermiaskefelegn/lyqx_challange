import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lyqx_challange/presentation/cart/screen/cart_screen.dart';
import 'package:lyqx_challange/presentation/welcome/welcome_page.dart';
import 'package:lyqx_challange/core/router/auth_gate.dart';
import '../../presentation/auth/screens/login_screen.dart';
import '../../presentation/product_details/screens/product_details_screen.dart';
import '../../presentation/products/screens/products_screen.dart';
import '../../presentation/wishlist/screens/wishlist_screen.dart';
import '../di/injection.dart';
import '../../domain/repositories/product_repository.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (context, state) => const AuthGate()),
    GoRoute(path: '/welcome', builder: (context, state) => const WelcomeScreen()),
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
    GoRoute(path: '/products', builder: (context, state) => const ProductsScreen()),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final id = int.parse(state.pathParameters['id']!);
        return ProductDetailLoader(productId: id);
      },
    ),
    GoRoute(path: '/cart', builder: (context, state) => const CartScreen()),
    GoRoute(path: '/wishlist', builder: (context, state) => const WishlistScreen()),
  ],
);

class ProductDetailLoader extends StatelessWidget {
  final int productId;

  const ProductDetailLoader({super.key, required this.productId});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getIt<ProductRepository>().getProductById(productId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        if (snapshot.hasError) {
          return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
        }

        if (snapshot.hasData) {
          return snapshot.data!.fold(
            (failure) => Scaffold(body: Center(child: Text('Error: ${failure.message}'))),
            (product) => ProductDetailsScreen(product: product),
          );
        }

        return const Scaffold(body: Center(child: Text('Product not found')));
      },
    );
  }
}
