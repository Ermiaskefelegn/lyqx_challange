// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:lyqx_challange/core/di/register_module.dart' as _i434;
import 'package:lyqx_challange/core/network/dio_client.dart' as _i677;
import 'package:lyqx_challange/core/services/secure_storage_service.dart'
    as _i1061;
import 'package:lyqx_challange/data/datasources/local/auth_local_datasource.dart'
    as _i724;
import 'package:lyqx_challange/data/datasources/remote/auth_remote_datasource.dart'
    as _i950;
import 'package:lyqx_challange/data/datasources/local/cart_local_datasource.dart'
    as _i1068;
import 'package:lyqx_challange/data/datasources/remote/product_remote_datasource.dart'
    as _i785;
import 'package:lyqx_challange/data/datasources/local/wishlist_local_datasource.dart'
    as _i282;
import 'package:lyqx_challange/data/repositories/auth_repository_impl.dart'
    as _i1066;
import 'package:lyqx_challange/data/repositories/cart_repository_impl.dart'
    as _i871;
import 'package:lyqx_challange/data/repositories/product_repository_impl.dart'
    as _i85;
import 'package:lyqx_challange/data/repositories/wishlist_repository_impl.dart'
    as _i168;
import 'package:lyqx_challange/domain/repositories/auth_repository.dart'
    as _i89;
import 'package:lyqx_challange/domain/repositories/cart_repository.dart'
    as _i829;
import 'package:lyqx_challange/domain/repositories/product_repository.dart'
    as _i137;
import 'package:lyqx_challange/domain/repositories/wishlist_repository.dart'
    as _i126;
import 'package:lyqx_challange/domain/usecases/cart_usecases.dart' as _i273;
import 'package:lyqx_challange/domain/usecases/get_products_usecase.dart'
    as _i857;
import 'package:lyqx_challange/domain/usecases/login_usecase.dart' as _i985;
import 'package:lyqx_challange/domain/usecases/wishlist_usecases.dart' as _i468;
import 'package:lyqx_challange/presentation/auth/bloc/auth_bloc.dart' as _i577;
import 'package:lyqx_challange/presentation/cart/bloc/cart_bloc.dart' as _i815;
import 'package:lyqx_challange/presentation/products/bloc/products_bloc.dart'
    as _i30;
import 'package:lyqx_challange/presentation/wishlist/bloc/wishlist_bloc.dart'
    as _i1013;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.lazySingleton<_i558.FlutterSecureStorage>(
      () => registerModule.secureStorage,
    );
    gh.lazySingleton<_i1061.SecureStorageService>(
      () => _i1061.SecureStorageService(),
    );
    gh.lazySingleton<_i677.DioClient>(
      () => _i677.DioClient(gh<_i1061.SecureStorageService>()),
    );
    gh.lazySingleton<_i282.WishlistLocalDataSource>(
      () => _i282.WishlistLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i126.WishlistRepository>(
      () => _i168.WishlistRepositoryImpl(gh<_i282.WishlistLocalDataSource>()),
    );
    gh.lazySingleton<_i1068.CartLocalDataSource>(
      () => _i1068.CartLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i724.AuthLocalDataSource>(
      () => _i724.AuthLocalDataSourceImpl(gh<_i460.SharedPreferences>()),
    );
    gh.lazySingleton<_i950.AuthRemoteDataSource>(
      () => _i950.AuthRemoteDataSourceImpl(gh<_i677.DioClient>()),
    );
    gh.factory<_i468.GetWishlistItemsUseCase>(
      () => _i468.GetWishlistItemsUseCase(gh<_i126.WishlistRepository>()),
    );
    gh.factory<_i468.AddToWishlistUseCase>(
      () => _i468.AddToWishlistUseCase(gh<_i126.WishlistRepository>()),
    );
    gh.factory<_i468.RemoveFromWishlistUseCase>(
      () => _i468.RemoveFromWishlistUseCase(gh<_i126.WishlistRepository>()),
    );
    gh.factory<_i468.IsInWishlistUseCase>(
      () => _i468.IsInWishlistUseCase(gh<_i126.WishlistRepository>()),
    );
    gh.factory<_i1013.WishlistBloc>(
      () => _i1013.WishlistBloc(
        gh<_i468.GetWishlistItemsUseCase>(),
        gh<_i468.AddToWishlistUseCase>(),
        gh<_i468.RemoveFromWishlistUseCase>(),
        gh<_i468.IsInWishlistUseCase>(),
      ),
    );
    gh.lazySingleton<_i785.ProductRemoteDataSource>(
      () => _i785.ProductRemoteDataSourceImpl(gh<_i677.DioClient>()),
    );
    gh.lazySingleton<_i829.CartRepository>(
      () => _i871.CartRepositoryImpl(gh<_i1068.CartLocalDataSource>()),
    );
    gh.factory<_i273.GetCartItemsUseCase>(
      () => _i273.GetCartItemsUseCase(gh<_i829.CartRepository>()),
    );
    gh.factory<_i273.AddToCartUseCase>(
      () => _i273.AddToCartUseCase(gh<_i829.CartRepository>()),
    );
    gh.factory<_i273.RemoveFromCartUseCase>(
      () => _i273.RemoveFromCartUseCase(gh<_i829.CartRepository>()),
    );
    gh.factory<_i273.UpdateCartQuantityUseCase>(
      () => _i273.UpdateCartQuantityUseCase(gh<_i829.CartRepository>()),
    );
    gh.lazySingleton<_i89.AuthRepository>(
      () => _i1066.AuthRepositoryImpl(
        gh<_i950.AuthRemoteDataSource>(),
        gh<_i724.AuthLocalDataSource>(),
      ),
    );
    gh.factory<_i815.CartBloc>(
      () => _i815.CartBloc(
        gh<_i273.GetCartItemsUseCase>(),
        gh<_i273.AddToCartUseCase>(),
        gh<_i273.RemoveFromCartUseCase>(),
        gh<_i273.UpdateCartQuantityUseCase>(),
      ),
    );
    gh.lazySingleton<_i137.ProductRepository>(
      () => _i85.ProductRepositoryImpl(gh<_i785.ProductRemoteDataSource>()),
    );
    gh.factory<_i985.LoginUseCase>(
      () => _i985.LoginUseCase(gh<_i89.AuthRepository>()),
    );
    gh.factory<_i857.GetProductsUseCase>(
      () => _i857.GetProductsUseCase(gh<_i137.ProductRepository>()),
    );
    gh.factory<_i30.ProductsBloc>(
      () => _i30.ProductsBloc(gh<_i857.GetProductsUseCase>()),
    );
    gh.factory<_i577.AuthBloc>(
      () => _i577.AuthBloc(gh<_i985.LoginUseCase>(), gh<_i89.AuthRepository>()),
    );
    return this;
  }
}

class _$RegisterModule extends _i434.RegisterModule {}
