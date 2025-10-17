import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:lyqx_challange/presentation/cart/bloc/cart.event.dart';
import '../../../domain/usecases/cart_usecases.dart';
import 'cart_state.dart';

@injectable
class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase getCartItemsUseCase;
  final AddToCartUseCase addToCartUseCase;
  final RemoveFromCartUseCase removeFromCartUseCase;
  final UpdateCartQuantityUseCase updateCartQuantityUseCase;

  CartBloc(this.getCartItemsUseCase, this.addToCartUseCase, this.removeFromCartUseCase, this.updateCartQuantityUseCase)
    : super(CartInitial()) {
    on<LoadCart>(_onLoadCart);
    on<AddToCartEvent>(_onAddToCart);
    on<RemoveFromCartEvent>(_onRemoveFromCart);
    on<UpdateCartQuantityEvent>(_onUpdateQuantity);
  }

  Future<void> _onLoadCart(LoadCart event, Emitter<CartState> emit) async {
    emit(CartLoading());

    final result = await getCartItemsUseCase();

    result.fold((failure) => emit(CartError(failure.message)), (items) {
      final total = items.fold<double>(0, (sum, item) => sum + item.totalPrice);
      emit(CartLoaded(items: items, total: total));
    });
  }

  Future<void> _onAddToCart(AddToCartEvent event, Emitter<CartState> emit) async {
    await addToCartUseCase(event.product);
    add(LoadCart());
  }

  Future<void> _onRemoveFromCart(RemoveFromCartEvent event, Emitter<CartState> emit) async {
    await removeFromCartUseCase(event.productId);
    add(LoadCart());
  }

  Future<void> _onUpdateQuantity(UpdateCartQuantityEvent event, Emitter<CartState> emit) async {
    await updateCartQuantityUseCase(event.productId, event.quantity);
    add(LoadCart());
  }
}
