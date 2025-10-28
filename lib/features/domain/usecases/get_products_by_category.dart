import 'package:dartz/dartz.dart';
import 'package:qodera_demo_app/core/error/failures.dart';
import 'package:qodera_demo_app/features/domain/entities/product.dart';
import 'package:qodera_demo_app/features/domain/repositories/product_repository.dart';

class GetProductsByCategory {
  final ProductRepository repository;

  GetProductsByCategory(this.repository);

  Future<Either<Failure, List<Product>>> call(String categoryName) async {
    return await repository.getProductsByCategory(categoryName);
  }
}
