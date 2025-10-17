import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/get_products_usecase.dart';
import 'products_event.dart';
import 'products_state.dart';

@injectable
class ProductsBloc extends Bloc<ProductsEvent, ProductsState> {
  final GetProductsUseCase getProductsUseCase;
  static const int _productsPerPage = 10;

  ProductsBloc(this.getProductsUseCase) : super(ProductsInitial()) {
    on<LoadProducts>(_onLoadProducts);
    on<LoadMoreProducts>(_onLoadMoreProducts);
    on<RefreshProducts>(_onRefreshProducts);
  }

  Future<void> _onLoadProducts(
    LoadProducts event,
    Emitter<ProductsState> emit,
  ) async {
    emit(ProductsLoading());

    final result = await getProductsUseCase(limit: _productsPerPage);

    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(
        products: products,
        hasReachedMax: products.length < _productsPerPage,
      )),
    );
  }

  Future<void> _onLoadMoreProducts(
    LoadMoreProducts event,
    Emitter<ProductsState> emit,
  ) async {
    if (state is ProductsLoaded) {
      final currentState = state as ProductsLoaded;

      if (currentState.hasReachedMax) return;

      final result = await getProductsUseCase(
        limit: _productsPerPage,
        offset: currentState.products.length,
      );

      result.fold(
        (failure) => emit(ProductsError(failure.message)),
        (products) {
          emit(
            currentState.copyWith(
              products: List.of(currentState.products)..addAll(products),
              hasReachedMax: products.isEmpty || products.length < _productsPerPage,
            ),
          );
        },
      );
    }
  }

  Future<void> _onRefreshProducts(
    RefreshProducts event,
    Emitter<ProductsState> emit,
  ) async {
    final result = await getProductsUseCase(limit: _productsPerPage);

    result.fold(
      (failure) => emit(ProductsError(failure.message)),
      (products) => emit(ProductsLoaded(
        products: products,
        hasReachedMax: products.length < _productsPerPage,
      )),
    );
  }
}
