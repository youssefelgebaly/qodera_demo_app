import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qodera_demo_app/features/domain/usecases/get_products_by_category.dart';
import '../../domain/usecases/get_products.dart';
import '../../domain/usecases/search_products.dart';
import '../../domain/repositories/product_repository.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final GetProducts getProducts;
  final SearchProducts searchProducts;
  final ProductRepository repository;
  final GetProductsByCategory getProductsByCategory;

  ProductBloc({
    required this.getProducts,
    required this.searchProducts,
    required this.repository,
    required this.getProductsByCategory,
  }) : super(ProductInitial()) {
    on(_onLoadProducts);
    on(_onSearchProducts);
    on(_onLoadProductsByCategory);
  }

  Future _onLoadProducts(LoadProducts event, Emitter emit) async {
    emit(ProductLoading());

    final productsResult = await getProducts();
    final categoriesResult = await repository.getCategories();

    productsResult.fold((failure) => emit(ProductError(failure.message)), (
      products,
    ) {
      categoriesResult.fold(
        (failure) => emit(ProductError(failure.message)),
        (categories) =>
            emit(ProductLoaded(products: products, categories: categories)),
      );
    });
  }

  Future _onSearchProducts(SearchProductsEvent event, Emitter emit) async {
    if (event.query.isEmpty) {
      add(LoadSearch());
      return;
    }
    emit(SearchLoading());
    final result = await searchProducts(event.query);
    result.fold(
      (failure) => emit(ProductError(failure.message)),
      (products) => emit(SearchLoaded(products: products)),
    );
  }

  Future<void> _onLoadProductsByCategory(
    LoadProductsByCategory event,
    Emitter<ProductState> emit,
  ) async {
    emit(ProductLoading());

    final result = await getProductsByCategory(event.categoryName);

    await result.fold(
      (failure) async {
        emit(ProductError(failure.message));
      },
      (products) async {
        if (state is ProductLoaded) {
          final currentState = state as ProductLoaded;
          emit(
            ProductLoaded(
              products: products,
              categories: currentState.categories,
              selectedCategoryIndex: event.selectedIndex,
            ),
          );
        } else {
          final categoriesResult = await repository.getCategories();

          categoriesResult.fold(
            (failure) => emit(ProductError(failure.message)),
            (categories) => emit(
              ProductLoaded(
                products: products,
                categories: categories,
                selectedCategoryIndex: event.selectedIndex,
              ),
            ),
          );
        }
      },
    );
  }
}
