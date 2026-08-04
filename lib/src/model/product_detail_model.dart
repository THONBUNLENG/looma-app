import 'product_model.dart';

class ProductDetailResponse {
  final ProductModel? product;
  final List<dynamic> variations;
  final List<ProductModel> relatedProducts;

  ProductDetailResponse({
    this.product,
    this.variations = const [],
    this.relatedProducts = const [],
  });

  factory ProductDetailResponse.fromJson(Map<String, dynamic> json) {
    return ProductDetailResponse(
      product: json['product'] != null ? ProductModel.fromMap(json['product']) : null,
      variations: json['variations'] is List ? json['variations'] : [],
      relatedProducts: json['related_products'] is List
          ? (json['related_products'] as List)
              .map((e) => ProductModel.fromMap(e))
              .toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product': product?.toJson(),
      'variations': variations,
      'related_products': relatedProducts.map((e) => e.toJson()).toList(),
    };
  }
}
