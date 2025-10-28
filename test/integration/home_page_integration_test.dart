import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:qodera_demo_app/features/domain/entities/category.dart';
import 'package:qodera_demo_app/features/domain/entities/product.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_bloc.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_state.dart';
import 'package:qodera_demo_app/features/presentation/pages/home_page.dart';

class MockProductBloc extends Mock implements ProductBloc {}

final sl = GetIt.instance;

class FakePathProviderPlatform extends Fake
    with MockPlatformInterfaceMixin
    implements PathProviderPlatform {
  @override
  Future<String?> getTemporaryPath() async => '.';
  @override
  Future<String?> getApplicationSupportPath() async => '.';
  @override
  Future<String?> getApplicationDocumentsPath() async => '.';
  @override
  Future<String?> getExternalStoragePath() async => '.';
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  PathProviderPlatform.instance = FakePathProviderPlatform();

  late MockProductBloc mockBloc;
  final fakeProducts = [Product.fake(), Product.fake()];
  final fakeCategories = [
    Categories(name: 'Phones', slug: 'phones', url: ''),
    Categories(name: 'Laptops', slug: 'laptops', url: ''),
  ];
  setUp(() {
    mockBloc = MockProductBloc();
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockBloc.close()).thenAnswer((_) async {});
    sl.registerFactory<ProductBloc>(() => mockBloc);
  });

  tearDown(() {
    sl.reset();
  });

  testWidgets('products and categories after loading', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(
      ProductLoaded(products: fakeProducts, categories: fakeCategories),
    );
    when(() => mockBloc.stream).thenAnswer(
      (_) => Stream.value(
        ProductLoaded(products: fakeProducts, categories: fakeCategories),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductBloc>.value(
          value: mockBloc,
          child: const HomePage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('PHONES'), findsOneWidget);
    expect(find.text('LAPTOPS'), findsOneWidget);
  });

  testWidgets('Shows error message when ProductError state', (
    WidgetTester tester,
  ) async {
    when(() => mockBloc.state).thenReturn(ProductError('Something went wrong'));
    when(
      () => mockBloc.stream,
    ).thenAnswer((_) => Stream.value(ProductError('Something went wrong')));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductBloc>.value(
          value: mockBloc,
          child: const HomePage(),
        ),
      ),
    );

    await tester.pump();

    expect(find.textContaining('Something went wrong'), findsOneWidget);
  });

  testWidgets('Shows loading state correctly', (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(ProductLoading());
    when(
      () => mockBloc.stream,
    ).thenAnswer((_) => Stream.value(ProductLoading()));

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<ProductBloc>.value(
          value: mockBloc,
          child: const HomePage(),
        ),
      ),
    );

    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byType(SizedBox), findsWidgets);
  });
}
