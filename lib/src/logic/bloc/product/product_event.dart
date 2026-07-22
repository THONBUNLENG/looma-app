part of 'product_bloc.dart';

@immutable
abstract class ProductEvent {}

class FetchProductsByCategory extends ProductEvent {
  final String category;
  FetchProductsByCategory(this.category);
}

class SearchProducts extends ProductEvent {
  final String query;
  final String category;
  SearchProducts(this.query, this.category);
}
