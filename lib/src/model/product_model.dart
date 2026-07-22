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
  final DateTime? createdAt;
  final String? stockStatus;
  final String? sku;
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
    this.createdAt,
    this.stockStatus,
    this.sku,
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
      createdAt: _parseDateTime(map['createdAt']),
      stockStatus: map['stock_status']?.toString(),
      sku: map['sku']?.toString(),
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
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'stock_status': stockStatus,
      'sku': sku,
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
      'createdAt': createdAt?.toIso8601String(),
      'stock_status': stockStatus,
      'sku': sku,
      'brand_id': brandId,
      'is_favorite': isFavorite,
    };
  }

  /// Converts the [ProductModel] to a JSON Map
  Map<String, dynamic> toJson() => toMap();

  /// Create a copy of [ProductModel] with modified fields
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
    DateTime? createdAt,
    String? stockStatus,
    String? sku,
    int? brandId,
    bool? isFavorite,
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
      createdAt: createdAt ?? this.createdAt,
      stockStatus: stockStatus ?? this.stockStatus,
      sku: sku ?? this.sku,
      brandId: brandId ?? this.brandId,
      isFavorite: isFavorite ?? this.isFavorite,
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
