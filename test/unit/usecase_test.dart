import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:qodera_demo_app/core/error/failures.dart';
import 'package:qodera_demo_app/features/domain/entities/product.dart';
import 'package:qodera_demo_app/features/domain/repositories/product_repository.dart';
import 'package:qodera_demo_app/features/domain/usecases/get_products.dart';

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late GetProducts useCase;
  late MockProductRepository mockRepository;
  final fakeProducts = [Product.fake(), Product.fake()];

  setUp(() {
    mockRepository = MockProductRepository();
    useCase = GetProducts(mockRepository);
  });

  group('GetProducts', () {
    test('get products from repository', () async {
      when(
        () => mockRepository.getProducts(),
      ).thenAnswer((_) async => Right(fakeProducts));

      final result = await useCase();

      expect(result, Right(fakeProducts));
      verify(() => mockRepository.getProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });

    test('failure when repository fails', () async {
      final tFailure = ServerFailure('Server error');
      when(
        () => mockRepository.getProducts(),
      ).thenAnswer((_) async => Left(tFailure));

      final result = await useCase();

      expect(result, Left(tFailure));
      verify(() => mockRepository.getProducts()).called(1);
      verifyNoMoreInteractions(mockRepository);
    });
  });
}
