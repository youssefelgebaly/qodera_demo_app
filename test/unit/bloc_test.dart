import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qodera_demo_app/core/error/failures.dart';
import 'package:qodera_demo_app/features/domain/entities/category.dart';
import 'package:qodera_demo_app/features/domain/entities/product.dart';
import 'package:qodera_demo_app/features/domain/repositories/product_repository.dart';
import 'package:qodera_demo_app/features/domain/usecases/get_products.dart';
import 'package:qodera_demo_app/features/domain/usecases/get_products_by_category.dart';
import 'package:qodera_demo_app/features/domain/usecases/search_products.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_bloc.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_event.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_state.dart';

class MockGetProducts extends Mock implements GetProducts {}

class MockSearchProducts extends Mock implements SearchProducts {}

class MockGetProductsByCategory extends Mock implements GetProductsByCategory {}

class MockProductRepository extends Mock implements ProductRepository {}

void main() {
  late MockGetProducts mockGetProducts;
  late MockSearchProducts mockSearchProducts;
  late MockGetProductsByCategory mockGetProductsByCategory;
  late MockProductRepository mockRepository;
  late ProductBloc bloc;
  final fakeProducts = [Product.fake(), Product.fake()];
  final fakeCategories = [Categories(name: 'Tech', slug: 'tech', url: '')];

  setUp(() {
    mockGetProducts = MockGetProducts();
    mockSearchProducts = MockSearchProducts();
    mockGetProductsByCategory = MockGetProductsByCategory();
    mockRepository = MockProductRepository();

    bloc = ProductBloc(
      getProducts: mockGetProducts,
      searchProducts: mockSearchProducts,
      repository: mockRepository,
      getProductsByCategory: mockGetProductsByCategory,
    );
  });

  group('ProductBloc', () {
    blocTest<ProductBloc, ProductState>(
      'LoadProducts is successful',
      build: () {
        when(
          () => mockGetProducts(),
        ).thenAnswer((_) async => Right(fakeProducts));
        when(
          () => mockRepository.getCategories(),
        ).thenAnswer((_) async => Right(fakeCategories));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [isA<ProductLoading>(), isA<ProductLoaded>()],
    );

    blocTest<ProductBloc, ProductState>(
      'LoadProducts fails',
      build: () {
        when(
          () => mockGetProducts(),
        ).thenAnswer((_) async => Left(ServerFailure('Server error')));
        when(
          () => mockRepository.getCategories(),
        ).thenAnswer((_) async => Right(fakeCategories));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadProducts()),
      expect: () => [isA<ProductLoading>(), isA<ProductError>()],
    );

    blocTest<ProductBloc, ProductState>(
      'LoadProductsByCategory is successful',
      build: () {
        when(
          () => mockGetProductsByCategory(any()),
        ).thenAnswer((_) async => Right(fakeProducts));
        when(
          () => mockRepository.getCategories(),
        ).thenAnswer((_) async => Right(fakeCategories));
        return bloc;
      },
      act: (bloc) => bloc.add(LoadProductsByCategory('tech', 0)),
      expect: () => [isA<ProductLoading>(), isA<ProductLoaded>()],
    );
  });
}
