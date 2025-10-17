import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lyqx_challange/presentation/cart/bloc/cart.event.dart';
import 'package:lyqx_challange/presentation/cart/bloc/cart_bloc.dart';
import '../../../core/di/injection.dart';
import '../../../domain/entities/product.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../wishlist/bloc/wishlist_event.dart';
import '../../wishlist/bloc/wishlist_state.dart';

class ProductDetailsScreen extends StatelessWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<CartBloc>()),
        BlocProvider(create: (_) => getIt<WishlistBloc>()..add(LoadWishlist())),
      ],
      child: ProductDetailsView(product: product),
    );
  }
}

class ProductDetailsView extends StatelessWidget {
  final Product product;

  const ProductDetailsView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 400,
                        color: const Color(0xFFF7F8F9),
                        child: CachedNetworkImage(
                          imageUrl: product.image,
                          fit: BoxFit.contain,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF1E232C)),
                                  onPressed: () => context.pop(),
                                ),
                              ),
                              BlocBuilder<WishlistBloc, WishlistState>(
                                builder: (context, state) {
                                  final isInWishlist =
                                      state is WishlistLoaded && state.products.any((p) => p.id == product.id);

                                  return CircleAvatar(
                                    backgroundColor: Colors.white,
                                    child: IconButton(
                                      icon: Icon(
                                        isInWishlist ? Icons.favorite : Icons.favorite_border,
                                        color: isInWishlist ? Colors.red : const Color(0xFF1E232C),
                                      ),
                                      onPressed: () {
                                        if (isInWishlist) {
                                          context.read<WishlistBloc>().add(RemoveFromWishlistEvent(product.id));
                                        } else {
                                          context.read<WishlistBloc>().add(AddToWishlistEvent(product));
                                        }
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product.title,
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E232C)),
                        ),
                        const SizedBox(height: 8),
                        Text('${product.category} Category', style: TextStyle(fontSize: 16, color: Colors.grey[600])),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 24),
                            const SizedBox(width: 8),
                            Text(
                              '${product.rating.rate} ',
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '(${product.rating.count} Reviews)',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Description',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1E232C)),
                        ),
                        const SizedBox(height: 12),
                        Text(product.description, style: TextStyle(fontSize: 15, color: Colors.grey[700], height: 1.5)),
                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Row(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Price', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E232C)),
                ),
              ],
            ),
            const SizedBox(width: 24),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<CartBloc>().add(AddToCartEvent(product));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Added to cart'),
                        duration: Duration(seconds: 1),
                        backgroundColor: Color(0xFF1E232C),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1E232C),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text(
                    'Add to cart',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
