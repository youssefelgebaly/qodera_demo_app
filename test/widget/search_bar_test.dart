import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_bloc.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_event.dart';
import 'package:qodera_demo_app/features/presentation/bloc/product_state.dart';
import 'package:qodera_demo_app/features/presentation/widgets/search_bar_widget.dart';

class MockProductBloc extends Mock implements ProductBloc {}

class FakeProductState extends Fake implements ProductState {}

class FakeProductEvent extends Fake implements ProductEvent {}

void main() {
  late MockProductBloc mockBloc;

  setUpAll(() {
    registerFallbackValue(FakeProductState());
    registerFallbackValue(FakeProductEvent());
  });

  setUp(() {
    mockBloc = MockProductBloc();
    when(() => mockBloc.stream).thenAnswer((_) => const Stream.empty());
    when(() => mockBloc.state).thenReturn(ProductInitial());
  });

  Widget buildTestableWidget() {
    return MaterialApp(
      home: BlocProvider<ProductBloc>.value(
        value: mockBloc,
        child: const Scaffold(body: SearchBarWidget()),
      ),
    );
  }

  group('SearchBarWidget UI Tests', () {
    testWidgets('display search bar with correct elements', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.byType(TextField), findsOneWidget);
      expect(find.byIcon(Icons.search), findsOneWidget);
      expect(find.text('Search products...'), findsOneWidget);
    });

    testWidgets('close button when empty', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('close button when text entered', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      await tester.enterText(find.byType(TextField), 'laptop');
      await tester.pump();

      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });

  group('SearchBarWidget Search Functionality', () {
    testWidgets('SearchProductsEvent', (tester) async {
      when(() => mockBloc.add(any())).thenAnswer((_) {});

      await tester.pumpWidget(buildTestableWidget());

      await tester.enterText(find.byType(TextField), 'laptop');
      await tester.pump(const Duration(milliseconds: 500));

      verify(() => mockBloc.add(SearchProductsEvent('laptop'))).called(1);
    });

    testWidgets('cancel previous timer on rapid typing', (tester) async {
      when(() => mockBloc.add(any())).thenAnswer((_) {});

      await tester.pumpWidget(buildTestableWidget());

      await tester.enterText(find.byType(TextField), 'lap');
      await tester.pump(const Duration(milliseconds: 200));

      await tester.enterText(find.byType(TextField), 'laptop');
      await tester.pump(const Duration(milliseconds: 500));
      verify(() => mockBloc.add(SearchProductsEvent('laptop'))).called(1);
      verifyNever(() => mockBloc.add(SearchProductsEvent('lap')));
    });

    testWidgets('event for empty query', (tester) async {
      when(() => mockBloc.add(any())).thenAnswer((_) {});

      await tester.pumpWidget(buildTestableWidget());

      await tester.enterText(find.byType(TextField), '');
      await tester.pump(const Duration(milliseconds: 500));

      verifyNever(() => mockBloc.add(any(that: isA<SearchProductsEvent>())));
    });
  });

  group('SearchBarWidget Loading State', () {
    testWidgets('indicator when SearchLoading state', (tester) async {
      when(() => mockBloc.state).thenReturn(SearchLoading());

      await tester.pumpWidget(buildTestableWidget());
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.close), findsNothing);
    });

    testWidgets('hide indicator when search completes', (tester) async {
      when(() => mockBloc.state).thenReturn(SearchLoaded(products: const []));

      await tester.pumpWidget(buildTestableWidget());

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });
  });

  group('SearchBarWidget Animation', () {
    testWidgets('animate container when text changes', (tester) async {
      await tester.pumpWidget(buildTestableWidget());

      AnimatedContainer emptyContainer = tester.widget(
        find.byType(AnimatedContainer),
      );
      BoxDecoration emptyDecoration =
          emptyContainer.decoration as BoxDecoration;

      await tester.enterText(find.byType(TextField), 'test');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      AnimatedContainer filledContainer = tester.widget(
        find.byType(AnimatedContainer),
      );
      BoxDecoration filledDecoration =
          filledContainer.decoration as BoxDecoration;

      expect(emptyDecoration.color, isNot(equals(filledDecoration.color)));
    });
  });
}
