import 'package:injectable/injectable.dart';
import 'package:lyqx_challange/core/network/exceptions.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/dio_client.dart';
import '../../models/product_model.dart';

abstract class ProductRemoteDataSource {
  Future<List<ProductModel>> getProducts({int? limit, int? offset});
  Future<ProductModel> getProductById(int id);
}

@LazySingleton(as: ProductRemoteDataSource)
class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final DioClient client;

  ProductRemoteDataSourceImpl(this.client);

  @override
  Future<List<ProductModel>> getProducts({int? limit, int? offset}) async {
    try {
      final queryParams = <String, dynamic>{};
      if (limit != null) queryParams['limit'] = limit;

      final response = await client.get(
        ApiConstants.productsEndpoint,
        queryParameters: queryParams.isNotEmpty ? queryParams : null,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final products = data.map((json) => ProductModel.fromJson(json)).toList();

        if (offset != null && offset > 0) {
          return products.skip(offset).toList();
        }

        return products;
      } else {
        throw NetworkException.custom(
          message: 'Failed to load products with status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw parseDioError(e);
    }
  }

  @override
  Future<ProductModel> getProductById(int id) async {
    try {
      final response = await client.get('${ApiConstants.productsEndpoint}/$id');

      if (response.statusCode == 200) {
        return ProductModel.fromJson(response.data);
      } else {
        throw NetworkException.custom(
          message: 'Failed to load product with status code: ${response.statusCode}',
          statusCode: response.statusCode,
        );
      }
    } catch (e) {
      throw parseDioError(e);
    }
  }
}
