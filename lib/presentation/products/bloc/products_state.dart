import 'package:equatable/equatable.dart';
import '../../../domain/entities/product.dart';

abstract class ProductsState extends Equatable {
  const ProductsState();

  @override
  List<Object> get props => [];
}

class ProductsInitial extends ProductsState {}

class ProductsLoading extends ProductsState {}

class ProductsLoaded extends ProductsState {
  final List<Product> products;
  final bool hasReachedMax;

  const ProductsLoaded({
    required this.products,
    this.hasReachedMax = false,
  });

  ProductsLoaded copyWith({
    List<Product>? products,
    bool? hasReachedMax,
  }) {
    return ProductsLoaded(
      products: products ?? this.products,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [products, hasReachedMax];
}

class ProductsError extends ProductsState {
  final String message;

  const ProductsError(this.message);

  @override
  List<Object> get props => [message];
}
