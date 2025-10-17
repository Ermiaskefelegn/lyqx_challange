import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lyqx_challange/presentation/auth/bloc/auth_state.dart';
import '../../../core/di/injection.dart';
import '../../auth/bloc/auth_bloc.dart';
import '../../auth/bloc/auth_event.dart';
import '../../wishlist/bloc/wishlist_bloc.dart';
import '../../wishlist/bloc/wishlist_event.dart';
import '../bloc/products_bloc.dart';
import '../bloc/products_event.dart';
import '../bloc/products_state.dart';
import '../widgets/product_card.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<ProductsBloc>()..add(LoadProducts())),
        BlocProvider(create: (_) => getIt<WishlistBloc>()..add(LoadWishlist())),
      ],
      child: const ProductsView(),
    );
  }
}

class ProductsView extends StatefulWidget {
  const ProductsView({super.key});

  @override
  State<ProductsView> createState() => _ProductsViewState();
}

class _ProductsViewState extends State<ProductsView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) {
      context.read<ProductsBloc>().add(LoadMoreProducts());
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 0.9);
  }

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
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      final username = state is Authenticated ? state.user.username : 'Username';
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Welcome,', style: TextStyle(fontSize: 18, color: Color(0xFF1E232C))),
                          Text(
                            username,
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E232C)),
                          ),
                        ],
                      );
                    },
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
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Fake Store',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1E232C)),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<ProductsBloc, ProductsState>(
                builder: (context, state) {
                  if (state is ProductsLoading) {
                    return const Center(child: CircularProgressIndicator(color: Color(0xFF1E232C)));
                  }

                  if (state is ProductsError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<ProductsBloc>().add(LoadProducts());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is ProductsLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<ProductsBloc>().add(RefreshProducts());
                      },
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: state.hasReachedMax ? state.products.length : state.products.length + 1,
                        itemBuilder: (context, index) {
                          if (index >= state.products.length) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(16.0),
                                child: CircularProgressIndicator(color: Color(0xFF1E232C)),
                              ),
                            );
                          }

                          final product = state.products[index];
                          return ProductCard(
                            product: product,
                            onTap: () {
                              context.push('/product/${product.id}');
                            },
                          );
                        },
                      ),
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
        currentIndex: 0,
        selectedItemColor: const Color(0xFF1E232C),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            context.push('/wishlist');
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
