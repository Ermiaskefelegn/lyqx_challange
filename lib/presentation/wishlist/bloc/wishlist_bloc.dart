import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../../domain/usecases/wishlist_usecases.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

@injectable
class WishlistBloc extends Bloc<WishlistEvent, WishlistState> {
  final GetWishlistItemsUseCase getWishlistItemsUseCase;
  final AddToWishlistUseCase addToWishlistUseCase;
  final RemoveFromWishlistUseCase removeFromWishlistUseCase;
  final IsInWishlistUseCase isInWishlistUseCase;

  WishlistBloc(
    this.getWishlistItemsUseCase,
    this.addToWishlistUseCase,
    this.removeFromWishlistUseCase,
    this.isInWishlistUseCase,
  ) : super(WishlistInitial()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<AddToWishlistEvent>(_onAddToWishlist);
    on<RemoveFromWishlistEvent>(_onRemoveFromWishlist);
  }

  Future<void> _onLoadWishlist(
    LoadWishlist event,
    Emitter<WishlistState> emit,
  ) async {
    emit(WishlistLoading());

    final result = await getWishlistItemsUseCase();

    result.fold(
      (failure) => emit(WishlistError(failure.message)),
      (products) => emit(WishlistLoaded(products)),
    );
  }

  Future<void> _onAddToWishlist(
    AddToWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    await addToWishlistUseCase(event.product);
    add(LoadWishlist());
  }

  Future<void> _onRemoveFromWishlist(
    RemoveFromWishlistEvent event,
    Emitter<WishlistState> emit,
  ) async {
    await removeFromWishlistUseCase(event.productId);
    add(LoadWishlist());
  }
}
