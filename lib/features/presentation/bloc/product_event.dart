import 'package:equatable/equatable.dart';

abstract class ProductEvent extends Equatable {
  const ProductEvent();

  @override
  List get props => [];
}

class LoadProductsByCategory extends ProductEvent {
  final String categoryName;
  final int? selectedIndex;
  const LoadProductsByCategory(this.categoryName, this.selectedIndex);
}

class LoadProducts extends ProductEvent {}

class LoadSearch extends ProductEvent {}

class SearchProductsEvent extends ProductEvent {
  final String query;

  const SearchProductsEvent(this.query);

  @override
  List get props => [query];
}
