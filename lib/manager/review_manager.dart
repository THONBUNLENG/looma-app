import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../src/model/review_model.dart';

class ReviewManager extends ChangeNotifier {
  static final ReviewManager _instance = ReviewManager._internal();
  factory ReviewManager() => _instance;
  ReviewManager._internal();

  final Map<String, List<ReviewModel>> _reviewsByProduct = {};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('local_reviews');
    if (data != null) {
      final Map<String, dynamic> decoded = jsonDecode(data);
      decoded.forEach((productId, reviews) {
        _reviewsByProduct[productId] = (reviews as List)
            .map((r) => ReviewModel.fromJson(r as Map<String, dynamic>))
            .toList();
      });
    }
  }

  List<ReviewModel> getReviews(String productId) {
    return _reviewsByProduct[productId] ?? [];
  }

  Future<void> addReview(String productId, ReviewModel review) async {
    if (!_reviewsByProduct.containsKey(productId)) {
      _reviewsByProduct[productId] = [];
    }
    _reviewsByProduct[productId]!.insert(0, review);
    
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final Map<String, dynamic> toSave = {};
    _reviewsByProduct.forEach((productId, reviews) {
      toSave[productId] = reviews.map((r) => r.toJson()).toList();
    });
    await prefs.setString('local_reviews', jsonEncode(toSave));
  }
}
