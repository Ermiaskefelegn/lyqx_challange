import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lyqx_challange/presentation/cart/bloc/cart.event.dart';
import 'package:lyqx_challange/presentation/cart/bloc/cart_bloc.dart';
import '../../../core/di/injection.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';

import '../bloc/wishlist_bloc.dart';
import '../bloc/wishlist_event.dart';
import '../bloc/wishlist_state.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<WishlistBloc>()..add(LoadWishlist())),
        BlocProvider(create: (_) => getIt<CartBloc>()),
      ],
      child: const WishlistView(),
    );
  }
}

class WishlistView extends StatelessWidget {
  const WishlistView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Wishlist',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF1E232C)),
                  ),
                  IconButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(LogoutRequested());
                      context.go('/');
                    },
                    icon: const Icon(Icons.logout),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<WishlistBloc, WishlistState>(
                builder: (context, state) {
                  if (state is WishlistLoading) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF1E232C)));
                  }

                  if (state is WishlistError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is WishlistLoaded) {
                    if (state.products.isEmpty) {
                      return const Center(child: Text('Your wishlist is empty'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: state.products.length,
                      itemBuilder: (context, index) {
                        final product = state.products[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF7F8F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: CachedNetworkImage(
                                    imageUrl: product.image,
                                    fit: BoxFit.contain,
                                    placeholder: (context, url) =>
                                        const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.title,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Color(0xFF1E232C),
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      '\$${product.price.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFF1E232C),
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      height: 36,
                                      child: OutlinedButton(
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
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Color(0xFF1E232C)),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                        ),
                                        child: const Text(
                                          'Add to cart',
                                          style: TextStyle(fontSize: 13, color: Color(0xFF1E232C)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  context.read<WishlistBloc>().add(RemoveFromWishlistEvent(product.id));
                                },
                                icon: const Icon(Icons.favorite, color: Colors.red),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: const Color(0xFF1E232C),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            context.go('/products');
          } else if (index == 2) {
            context.push('/cart');
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: ''),
        ],
      ),
    );
  }
}
