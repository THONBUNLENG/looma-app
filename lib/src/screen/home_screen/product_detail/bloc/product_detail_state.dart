part of 'product_detail_bloc.dart';

@immutable
class ProductDetailState {
  final ProductModel product;
  final List<ProductModel> relatedProducts;
  final List<dynamic> variations;
  final bool isFavorite;
  final int selectedSize;
  final int selectedColor;
  final int quantity;
  final int currentPage;

  const ProductDetailState({
    required this.product,
    required this.relatedProducts,
    required this.variations,
    required this.isFavorite,
    required this.selectedSize,
    required this.selectedColor,
    required this.quantity,
    required this.currentPage,
  });

  ProductDetailState copyWith({
    ProductModel? product,
    List<ProductModel>? relatedProducts,
    List<dynamic>? variations,
    bool? isFavorite,
    int? selectedSize,
    int? selectedColor,
    int? quantity,
    int? currentPage,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      relatedProducts: relatedProducts ?? this.relatedProducts,
      variations: variations ?? this.variations,
      isFavorite: isFavorite ?? this.isFavorite,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: selectedColor ?? this.selectedColor,
      quantity: quantity ?? this.quantity,
      currentPage: currentPage ?? this.currentPage,
    );
  }
}

class ProductDetailInitial extends ProductDetailState {
  const ProductDetailInitial(
    ProductModel product,
    bool isFavorite, {
    super.relatedProducts = const [],
    super.variations = const [],
  }) : super(
         product: product,
         isFavorite: isFavorite,
         selectedSize: 1,
         selectedColor: 0,
         quantity: 1,
         currentPage: 0,
       );
}
