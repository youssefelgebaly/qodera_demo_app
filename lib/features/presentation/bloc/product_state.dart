import 'package:equatable/equatable.dart';
import 'package:qodera_demo_app/features/domain/entities/category.dart';
import 'package:qodera_demo_app/features/domain/entities/product.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List get props => [];
}

class ProductInitial extends ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final List<Product> products;
  final List<Categories> categories;
  final int? selectedCategoryIndex;

  const ProductLoaded({
    required this.products,
    required this.categories,
    this.selectedCategoryIndex,
  });

  @override
  List get props => [products, categories];

  ProductLoaded copyWith({
    List<Product>? products,
    List<Categories>? categories,
    int? selectedCategoryIndex,
  }) {
    return ProductLoaded(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }
}

class ProductError extends ProductState {
  final String message;

  const ProductError(this.message);

  @override
  List get props => [message];
}

class SearchLoading extends ProductState {}

class SearchLoaded extends ProductState {
  final List<Product> products;

  const SearchLoaded({required this.products});

  @override
  List get props => [products];

  SearchLoaded copyWith({List<Product>? products, String? searchQuery}) {
    return SearchLoaded(products: products ?? this.products);
  }
}

class SearchError extends ProductState {
  final String message;

  const SearchError(this.message);

  @override
  List get props => [message];
}
