import 'package:dartz/dartz.dart';
import 'package:qodera_demo_app/core/error/api_error_handler.dart';
import 'package:qodera_demo_app/core/error/failures.dart';
import 'package:qodera_demo_app/features/data/models/category_model.dart';
import 'package:qodera_demo_app/features/data/models/product_model.dart';
import 'package:qodera_demo_app/features/domain/entities/category.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_data_source.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDataSource remoteDataSource;

  ProductRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final result = await remoteDataSource.getProducts();
      final data = result['products'] as List<dynamic>;

      final products = data
          .map((json) => ProductModel.fromJson(json).toEntity())
          .toList();

      return Right(products);
    } catch (e) {
      return Left(ApiFailureHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> searchProducts(String query) async {
    try {
      if (query.isEmpty) {
        return await getProducts();
      }
      final result = await remoteDataSource.searchProducts(query);
      final data = result['products'] as List<dynamic>;
      final products = data
          .map((json) => ProductModel.fromJson(json).toEntity())
          .toList();
      return Right(products);
    } catch (e) {
      return Left(ApiFailureHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Categories>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      final List<dynamic> data = result as List<dynamic>;
      final List<Categories> categories = data
          .map((json) => CategoryModel.fromJson(json).toEntity())
          .toList();

      return Right(categories);
    } catch (e) {
      return Left(ApiFailureHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String categoryName,
  ) async {
    try {
      final result = await remoteDataSource.getProductsByCategory(categoryName);
      final data = result['products'] as List<dynamic>;

      final products = data
          .map((json) => ProductModel.fromJson(json).toEntity())
          .toList();

      return Right(products);
    } catch (e) {
      return Left(ApiFailureHandler.handle(e));
    }
  }
}
