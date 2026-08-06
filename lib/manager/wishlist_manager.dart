import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shopping_app/src/network/shared_preferences/shared_preferences.dart';
import 'package:shopping_app/src/network/crud_firebase/firestore_service.dart';

class WishlistManager extends ChangeNotifier {
  static final WishlistManager _instance = WishlistManager._internal();

  factory WishlistManager() => _instance;

  WishlistManager._internal();

  final List<Map<String, dynamic>> _wishlistItems = [];

  List<Map<String, dynamic>> get wishlistItems =>
      List.unmodifiable(_wishlistItems);

  Future<void> init() async {
    final String? wishlistData = SharedPrefUtil.getString(
      PrefKey.wishlistItems,
    );
    if (wishlistData != null && wishlistData.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(wishlistData);
        _wishlistItems.clear();
        _wishlistItems.addAll(
          decoded.map((item) => Map<String, dynamic>.from(item)),
        );
        notifyListeners();
      } catch (e) {
        debugPrint("Error decoding wishlist data: $e");
      }
    }
  }

  Future<void> toggleWishlist(Map<String, dynamic> product) async {
    final productId = product['id']?.toString() ?? product['title']?.toString();
    if (productId == null) return;

    final existingIndex = _wishlistItems.indexWhere(
      (item) => (item['id']?.toString() ?? item['title']?.toString()) == productId,
    );

    if (existingIndex != -1) {
      _wishlistItems.removeAt(existingIndex);
    } else {
      // Create a fresh copy to avoid modifying the original source
      final itemToAdd = Map<String, dynamic>.from(product);
      itemToAdd['is_favorite'] = true;
      _wishlistItems.add(itemToAdd);
    }
    await _saveToPrefs();
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> product) {
    final productId = product['id']?.toString() ?? product['title']?.toString();
    if (productId == null) return false;

    return _wishlistItems.any(
      (item) => (item['id']?.toString() ?? item['title']?.toString()) == productId,
    );
  }

  Future<void> removeFromWishlist(int index) async {
    if (index >= 0 && index < _wishlistItems.length) {
      _wishlistItems.removeAt(index);
      await _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> clearWishlist() async {
    _wishlistItems.clear();
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final String encoded = jsonEncode(_wishlistItems);
    await SharedPrefUtil.saveString(PrefKey.wishlistItems, encoded);

    // Sync to Firestore if logged in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirestoreService().updateUserWishlist(user.uid, _wishlistItems);
    }
  }

  int get wishlistCount => _wishlistItems.length;
}
