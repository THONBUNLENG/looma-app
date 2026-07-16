import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_app/src/network/shared_preferences/shared_preferences.dart';

class CartManager extends ChangeNotifier {
  static final CartManager _instance = CartManager._internal();
  factory CartManager() => _instance;
  CartManager._internal();

  final List<Map<String, dynamic>> _cartItems = [];

  List<Map<String, dynamic>> get cartItems => List.unmodifiable(_cartItems);

  Future<void> init() async {
    final String? cartData = SharedPrefUtil.getString(PrefKey.cartItems);
    if (cartData != null && cartData.isNotEmpty) {
      try {
        final List<dynamic> decoded = jsonDecode(cartData);
        _cartItems.clear();
        _cartItems.addAll(decoded.map((item) => Map<String, dynamic>.from(item)));
      } catch (e) {
        debugPrint("Error decoding cart data: $e");
      }
    }
  }

  Future<void> addToCart(Map<String, dynamic> product) async {
    // Check if item already exists in cart (by id or title if id is missing)
    final productId = product['id'] ?? product['title'];
    final existingIndex = _cartItems.indexWhere((item) => (item['id'] ?? item['title']) == productId);

    if (existingIndex != -1) {
      // Update quantity
      _cartItems[existingIndex]['quantity'] = (_cartItems[existingIndex]['quantity'] ?? 1) + (product['quantity'] ?? 1);
    } else {
      // Add new item
      product['isSelected'] = true;
      _cartItems.add(product);
    }
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> toggleSelection(int index) async {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index]['isSelected'] = !(_cartItems[index]['isSelected'] ?? true);
      await _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> selectAll(bool selected) async {
    for (var item in _cartItems) {
      item['isSelected'] = selected;
    }
    await _saveToPrefs();
    notifyListeners();
  }

  bool get isAllSelected => _cartItems.isNotEmpty && _cartItems.every((item) => item['isSelected'] == true);

  Future<void> removeFromCart(int index) async {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems.removeAt(index);
      await _saveToPrefs();
      notifyListeners();
    }
  }

  Future<void> updateQuantity(int index, int delta) async {
    if (index >= 0 && index < _cartItems.length) {
      final newQuantity = (_cartItems[index]['quantity'] ?? 1) + delta;
      if (newQuantity > 0) {
        _cartItems[index]['quantity'] = newQuantity;
        await _saveToPrefs();
        notifyListeners();
      }
    }
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await _saveToPrefs();
    notifyListeners();
  }

  Future<void> _saveToPrefs() async {
    final String encoded = jsonEncode(_cartItems);
    await SharedPrefUtil.saveString(PrefKey.cartItems, encoded);
  }

  int get cartCount => _cartItems.length;

  int get totalQuantity => _cartItems.fold(0, (sum, item) => sum + (item['quantity'] as int? ?? 1));

  double get subtotal => _cartItems.fold(0.0, (sum, item) {
        if (item['isSelected'] == false) return sum;
        final price = _parsePrice(item['price']);
        final quantity = item['quantity'] ?? 1;
        return sum + (price * quantity);
      });

  double _parsePrice(dynamic price) {
    if (price == null) return 0.0;
    if (price is num) return price.toDouble();
    return double.tryParse(
          price.toString().replaceAll(RegExp(r'[^\d.]'), ''),
        ) ??
        0.0;
  }
}
