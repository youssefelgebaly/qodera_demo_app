import 'package:dartz/dartz.dart';
import 'package:qodera_demo_app/core/error/failures.dart';
import 'package:qodera_demo_app/features/domain/entities/category.dart';
import 'package:qodera_demo_app/features/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, List<Categories>>> getCategories();
  Future<Either<Failure, List<Product>>> searchProducts(String query);
  Future<Either<Failure, List<Product>>> getProductsByCategory(
    String categoryName,
  );
}
