// import 'package:dio/dio.dart';
// import 'package:retrofit/retrofit.dart';
// import 'package:qodera_demo_app/core/constants/api_constants.dart';
// part 'product_remote_data_source.g.dart';

// @RestApi(baseUrl: ApiConstants.baseUrl)
// abstract class ProductRemoteDataSource {
//   factory ProductRemoteDataSource(Dio dio, {String baseUrl}) =
//       _ProductRemoteDataSource;

//   @GET(ApiConstants.products)
//   Future getProducts();

//   @GET(ApiConstants.search)
//   Future searchProducts(@Query('q') String query);

//   @GET(ApiConstants.categories)
//   Future getCategories();
// }

import 'package:dio/dio.dart';
import 'package:qodera_demo_app/core/constants/api_constants.dart';
import 'package:retrofit/retrofit.dart';

part 'product_remote_data_source.g.dart';

@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ProductRemoteDataSource {
  factory ProductRemoteDataSource(Dio dio, {String? baseUrl}) =
      _ProductRemoteDataSource;

  @GET(ApiConstants.products)
  Future getProducts();

  @GET(ApiConstants.search)
  Future searchProducts(@Query('q') String query);

  @GET(ApiConstants.categories)
  Future getCategories();

  @GET('${ApiConstants.categoryProducts}/{categoryName}')
  Future getProductsByCategory(@Path('categoryName') String categoryName);
}
