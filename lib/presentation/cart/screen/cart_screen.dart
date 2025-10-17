import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lyqx_challange/presentation/cart/bloc/cart.event.dart';
import 'package:lyqx_challange/presentation/cart/bloc/cart_state.dart';
import '../../../core/di/injection.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../bloc/cart_bloc.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (_) => getIt<CartBloc>()..add(LoadCart()), child: const CartView());
  }
}

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Cart',
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
              child: BlocBuilder<CartBloc, CartState>(
                builder: (context, state) {
                  if (state is CartLoading) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF1E232C)));
                  }

                  if (state is CartError) {
                    return Center(child: Text(state.message));
                  }

                  if (state is CartLoaded) {
                    if (state.items.isEmpty) {
                      return const Center(child: Text('Your cart is empty'));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: state.items.length,
                      itemBuilder: (context, index) {
                        final item = state.items[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    width: 80,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFF7F8F9),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: CachedNetworkImage(
                                        imageUrl: item.product.image,
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
                                          item.product.title,
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
                                          '\$${item.product.price.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1E232C),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 8),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF7F8F9),
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            IconButton(
                                              icon: const Icon(Icons.remove_circle_outline, size: 20),
                                              onPressed: () {
                                                if (item.quantity > 1) {
                                                  context.read<CartBloc>().add(
                                                    UpdateCartQuantityEvent(item.product.id, item.quantity - 1),
                                                  );
                                                }
                                              },
                                            ),
                                            Text(
                                              '${item.quantity}',
                                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.add_circle_outline, size: 20),
                                              onPressed: () {
                                                context.read<CartBloc>().add(
                                                  UpdateCartQuantityEvent(item.product.id, item.quantity + 1),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEF4444),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '\$${item.totalPrice.toStringAsFixed(2)}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        context.read<CartBloc>().add(RemoveFromCartEvent(item.product.id));
                                      },
                                      child: const Icon(Icons.delete_outline, color: Colors.white),
                                    ),
                                  ],
                                ),
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
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final total = state is CartLoaded ? state.total : 0.0;
              return Container(
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
                        Text('Cart total', style: TextStyle(fontSize: 14, color: Colors.grey[600])),
                        Text(
                          '\$${total.toStringAsFixed(2)}',
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
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Checkout functionality'),
                                backgroundColor: Color(0xFF1E232C),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E232C),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            'Checkout',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          BottomNavigationBar(
            currentIndex: 2,
            selectedItemColor: const Color(0xFF1E232C),
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              if (index == 0) {
                context.go('/products');
              } else if (index == 1) {
                context.push('/wishlist');
              }
            },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.favorite_border), label: ''),
              BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: ''),
            ],
          ),
        ],
      ),
    );
  }
}
