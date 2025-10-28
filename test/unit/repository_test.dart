import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qodera_demo_app/features/data/datasources/product_remote_data_source.dart';
import 'package:qodera_demo_app/features/data/repositories/product_repository_impl.dart';

class MockProductRemoteDataSource extends Mock
    implements ProductRemoteDataSource {}

void main() {
  late ProductRepositoryImpl repository;
  late MockProductRemoteDataSource mockDataSource;

  final fakeProductsResponse = {
    'products': [
      {
        'id': 1,
        'title': 'Apple',
        'price': 100.0,
        'description': 'A cool device',
        'category': 'phones',
        'thumbnail': 'url1',
      },
      {
        'id': 2,
        'title': 'Apple 2',
        'price': 200.0,
        'description': 'Another cool device',
        'category': 'laptops',
        'thumbnail': 'url2',
      },
    ],
  };

  final fakeSearchResponse = {
    'products': [
      {
        'id': 3,
        'title': 'Apple Phone',
        'price': 150.0,
        'description': 'High performance phone',
        'category': 'phones',
        'thumbnail': 'url3',
      },
    ],
  };

  final fakeCategoriesResponse = [
    {
      'slug': 'phones',
      'name': 'Phones',
      'url': 'https://dummyjson.com/products/category/phones',
    },
    {
      'slug': 'laptops',
      'name': 'Laptops',
      'url': 'https://dummyjson.com/products/category/laptops',
    },
  ];

  final fakeCategoryProductsResponse = {
    'products': [
      {
        'id': 4,
        'title': 'Laptop 1',
        'price': 1000.0,
        'description': 'Gaming laptop',
        'category': 'laptops',
        'thumbnail': 'url4',
      },
      {
        'id': 5,
        'title': 'Laptop 2',
        'price': 1500.0,
        'description': 'Business laptop',
        'category': 'laptops',
        'thumbnail': 'url5',
      },
    ],
  };

  setUp(() {
    mockDataSource = MockProductRemoteDataSource();
    repository = ProductRepositoryImpl(mockDataSource);
  });

  group('getProducts', () {
    test('products when data source call succeeds', () async {
      when(
        () => mockDataSource.getProducts(),
      ).thenAnswer((_) async => fakeProductsResponse);

      final result = await repository.getProducts();

      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected products, got failure'), (
        products,
      ) {
        expect(products.length, 2);
        expect(products.first.title, 'Apple');
      });
      verify(() => mockDataSource.getProducts()).called(1);
    });

    test('failure when exception is thrown', () async {
      when(
        () => mockDataSource.getProducts(),
      ).thenThrow(Exception('Network error'));

      final result = await repository.getProducts();

      expect(result.isLeft(), true);
      verify(() => mockDataSource.getProducts()).called(1);
    });
  });

  group('searchProducts', () {
    const query = 'apple';

    test('search results when query is provided', () async {
      when(
        () => mockDataSource.searchProducts(query),
      ).thenAnswer((_) async => fakeSearchResponse);

      final result = await repository.searchProducts(query);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected products, got failure'), (
        products,
      ) {
        expect(products.length, 1);
        expect(products.first.title, 'Apple Phone');
      });
      verify(() => mockDataSource.searchProducts(query)).called(1);
    });

    test('products when query is empty', () async {
      when(
        () => mockDataSource.getProducts(),
      ).thenAnswer((_) async => fakeProductsResponse);

      final result = await repository.searchProducts('');

      expect(result.isRight(), true);
      verify(() => mockDataSource.getProducts()).called(1);
      verifyNever(() => mockDataSource.searchProducts(any()));
    });

    test('failure when search fails', () async {
      when(
        () => mockDataSource.searchProducts(query),
      ).thenThrow(Exception('Search error'));

      final result = await repository.searchProducts(query);

      expect(result.isLeft(), true);
      verify(() => mockDataSource.searchProducts(query)).called(1);
    });
  });

  group('getCategories', () {
    test('categories when call succeeds', () async {
      when(
        () => mockDataSource.getCategories(),
      ).thenAnswer((_) async => fakeCategoriesResponse);

      final result = await repository.getCategories();

      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected categories'), (categories) {
        expect(categories.length, 2);
        expect(categories.first.slug, 'phones');
      });
      verify(() => mockDataSource.getCategories()).called(1);
    });

    test('failure when call fails', () async {
      when(
        () => mockDataSource.getCategories(),
      ).thenThrow(Exception('Network error'));

      final result = await repository.getCategories();

      expect(result.isLeft(), true);
      verify(() => mockDataSource.getCategories()).called(1);
    });
  });

  group('getProductsByCategory', () {
    const category = 'laptops';

    test('products for the given category', () async {
      when(
        () => mockDataSource.getProductsByCategory(category),
      ).thenAnswer((_) async => fakeCategoryProductsResponse);

      final result = await repository.getProductsByCategory(category);

      expect(result.isRight(), true);
      result.fold((failure) => fail('Expected products, got failure'), (
        products,
      ) {
        expect(products.length, 2);
        expect(products.first.title, 'Laptop 1');
      });
      verify(() => mockDataSource.getProductsByCategory(category)).called(1);
    });

    test('failure when call fails', () async {
      when(
        () => mockDataSource.getProductsByCategory(category),
      ).thenThrow(Exception('Category not found'));

      final result = await repository.getProductsByCategory(category);

      expect(result.isLeft(), true);
      verify(() => mockDataSource.getProductsByCategory(category)).called(1);
    });
  });
}
