import 'package:equatable/equatable.dart';

abstract class ProductsEvent extends Equatable {
  const ProductsEvent();

  @override
  List<Object> get props => [];
}

class LoadProducts extends ProductsEvent {}

class LoadMoreProducts extends ProductsEvent {}

class RefreshProducts extends ProductsEvent {}
