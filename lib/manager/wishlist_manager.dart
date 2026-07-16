import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/network/shared_preferences/shared_preferences.dart';

class WishlistManager {
  static final WishlistManager _instance = WishlistManager._internal();
  factory WishlistManager() => _instance;
  WishlistManager._internal();

  final List<Map<String, dynamic>> _wishlistItems = [];

  List<Map<String, dynamic>> get wishlistItems => List.unmodifiable(_wishlistItems);

  Future<void> init() async {
    final String? wishlistData = SharedPrefUtil.getString(PrefKey.wishlistItems);
    if (wishlistData != null && wishlistData.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(wishlistData);
        _wishlistItems.clear();
        _wishlistItems.addAll(decoded.map((item) => Map<String, dynamic>.from(item)));
      } catch (e) {
        debugPrint("Error decoding wishlist data: $e");
      }
    }
  }

  Future<void> toggleWishlist(Map<String, dynamic> product) async {
    final productId = product['id'] ?? product['title'];
    final existingIndex = _wishlistItems.indexWhere((item) => (item['id'] ?? item['title']) == productId);

    if (existingIndex != -1) {
      _wishlistItems.removeAt(existingIndex);
    } else {
      _wishlistItems.add(product);
    }
    await _saveToPrefs();
  }

  bool isFavorite(Map<String, dynamic> product) {
    final productId = product['id'] ?? product['title'];
    return _wishlistItems.any((item) => (item['id'] ?? item['title']) == productId);
  }

  Future<void> removeFromWishlist(int index) async {
    if (index >= 0 && index < _wishlistItems.length) {
      _wishlistItems.removeAt(index);
      await _saveToPrefs();
    }
  }

  Future<void> clearWishlist() async {
    _wishlistItems.clear();
    await _saveToPrefs();
  }

  Future<void> _saveToPrefs() async {
    final String encoded = jsonEncode(_wishlistItems);
    await SharedPrefUtil.saveString(PrefKey.wishlistItems, encoded);
  }

  int get wishlistCount => _wishlistItems.length;
}


