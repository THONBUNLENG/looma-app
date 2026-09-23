part of 'style_product_bloc.dart';

@immutable
sealed class StyleProductState {}

final class StyleProductInitial extends StyleProductState {}

final class StyleProductLoading extends StyleProductState {}

final class StyleProductLoaded extends StyleProductState {
  final List<Map<String, dynamic>> products;
  final String selectedStyle;
  final String searchQuery;

  StyleProductLoaded({
    required this.products,
    this.selectedStyle = "ALL",
    this.searchQuery = "",
  });

  StyleProductLoaded copyWith({
    List<Map<String, dynamic>>? products,
    String? selectedStyle,
    String? searchQuery,
  }) {
    return StyleProductLoaded(
      products: products ?? this.products,
      selectedStyle: selectedStyle ?? this.selectedStyle,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

final class StyleProductError extends StyleProductState {
  final String message;
  StyleProductError(this.message);
}
