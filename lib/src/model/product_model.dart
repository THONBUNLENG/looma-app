import 'package:cloud_firestore/cloud_firestore.dart';

class ProductModel {
  final String? id;
  final String title;
  final double price;
  final String? description;
  final List<String> images;
  final double rating;
  final String? sold;
  final int? reviews;
  final String category;
  final String? subCategory;
  final String? gender;
  final List<String> sizes;
  final List<String> colors;
  final List<String> imageColor;
  final String? discount;
  final DateTime? createdAt;
  final String? stockStatus;
  final String? sku;
  final String? brandName;
  final int? brandId;
  final bool isFavorite;

  ProductModel({
    this.id,
    required this.title,
    required this.price,
    this.description,
    required this.images,
    required this.rating,
    this.sold,
    this.reviews,
    required this.category,
    this.subCategory,
    this.gender,
    this.sizes = const [],
    this.colors = const [],
    this.imageColor = const [],
    this.discount,
    this.createdAt,
    this.stockStatus,
    this.sku,
    this.brandName,
    this.brandId,
    this.isFavorite = false,
  });

  /// Factory constructor to create a [ProductModel] from a Map (Firestore or JSON)
  factory ProductModel.fromMap(Map<String, dynamic> map, {String? docId}) {
    return ProductModel(
      id: docId ?? map['id']?.toString(),
      title: map['title']?.toString() ?? map['name']?.toString() ?? '',
      price: _parsePrice(map['price']),
      description: map['description']?.toString(),
      images: _parseImages(map),
      rating: _parseRating(map['rating']),
      sold: map['sold']?.toString(),
      reviews: _parseInt(map['reviews']),
      category: map['category']?.toString() ?? 'uncategorized',
      subCategory: map['subCategory']?.toString(),
      gender: map['gender']?.toString(),
      sizes: _parseList(map['sizes'] ?? map['size']),
      colors: _parseList(map['colors'] ?? map['color']),
      imageColor: _parseList(map['image_color']),
      discount: map['discount']?.toString(),
      createdAt: _parseDateTime(map['createdAt']),
      stockStatus: map['stock_status']?.toString(),
      sku: map['sku']?.toString(),
      brandName: map['brand_name']?.toString() ?? map['brand']?.toString(),
      brandId: _parseInt(map['brand_id']),
      isFavorite: map['is_favorite'] == true,
    );
  }

  /// Converts the [ProductModel] to a Map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'price': price,
      'description': description,
      'images': images,
      'rating': rating,
      'sold': sold,
      'reviews': reviews,
      'category': category,
      'subCategory': subCategory,
      'gender': gender,
      'sizes': sizes,
      'colors': colors,
      'image_color': imageColor,
      'discount': discount,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'stock_status': stockStatus,
      'sku': sku,
      'brand_name': brandName,
      'brand_id': brandId,
      'is_favorite': isFavorite,
    };
  }

  /// Converts the [ProductModel] to a Map for JSON/General use
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'price': price,
      'description': description,
      'images': images,
      'rating': rating,
      'sold': sold,
      'reviews': reviews,
      'category': category,
      'subCategory': subCategory,
      'gender': gender,
      'sizes': sizes,
      'colors': colors,
      'image_color': imageColor,
      'discount': discount,
      'createdAt': createdAt?.toIso8601String(),
      'stock_status': stockStatus,
      'sku': sku,
      'brand_name': brandName,
      'brand_id': brandId,
      'is_favorite': isFavorite,
    };
  }
  Map<String, dynamic> toJson() => toMap();

  ProductModel copyWith({
    String? id,
    String? title,
    double? price,
    String? description,
    List<String>? images,
    double? rating,
    String? sold,
    int? reviews,
    String? category,
    String? subCategory,
    String? gender,
    DateTime? createdAt,
    String? stockStatus,
    String? sku,
    String? brandName,
    int? brandId,
    bool? isFavorite,
    List<String>? sizes,
    List<String>? colors,
    List<String>? imageColor,
    String? discount,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      price: price ?? this.price,
      description: description ?? this.description,
      images: images ?? this.images,
      rating: rating ?? this.rating,
      sold: sold ?? this.sold,
      reviews: reviews ?? this.reviews,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      gender: gender ?? this.gender,
      createdAt: createdAt ?? this.createdAt,
      stockStatus: stockStatus ?? this.stockStatus,
      sku: sku ?? this.sku,
      brandName: brandName ?? this.brandName,
      brandId: brandId ?? this.brandId,
      isFavorite: isFavorite ?? this.isFavorite,
      sizes: sizes ?? this.sizes,
      colors: colors ?? this.colors,
      imageColor: imageColor ?? this.imageColor,
      discount: discount ?? this.discount,
    );
  }

  /// Helper to parse images from 'images' (List) or 'image' (String)
  static List<String> _parseImages(Map<String, dynamic> map) {
    if (map['images'] != null && map['images'] is List) {
      return (map['images'] as List).map((e) => e.toString()).toList();
    }
    if (map['image'] != null && map['image'] is String) {
      return [map['image'] as String];
    }
    return [];
  }

  // ignore: unintended_html_in_doc_comment
  /// Helper to parse List<String> from dynamic
  static List<String> _parseList(dynamic value) {
    if (value == null || value == false) return [];
    if (value is List) {
      return value.map((e) => e.toString()).toList();
    }
    if (value is String) {
      if (value.isEmpty) return [];
      return value.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    }
    return [];
  }

  /// Helper to parse price from string like "$1,200.00" or double
  static double _parsePrice(dynamic price) {
    if (price == null || price == false) return 0.0;
    if (price is num) return price.toDouble();
    if (price is String) {
      final cleaned = price.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(cleaned) ?? 0.0;
    }
    return 0.0;
  }

  /// Helper to parse rating from string or num
  static double _parseRating(dynamic rating) {
    if (rating == null || rating == false) return 0.0;
    if (rating is num) return rating.toDouble();
    if (rating is String) return double.tryParse(rating) ?? 0.0;
    return 0.0;
  }

  /// Helper to parse int (reviews, brandId)
  static int? _parseInt(dynamic value) {
    if (value == null || value == false) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Helper to parse DateTime from Firestore Timestamp, String or int
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is Timestamp) return value.toDate();
    if (value is String) return DateTime.tryParse(value);
    if (value is int) return DateTime.fromMillisecondsSinceEpoch(value);
    return null;
  }
}
