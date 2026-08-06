import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../model/order_model.dart';
import '../../model/product_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Get products by category, subCategory, and brandName
  Stream<List<ProductModel>> getProducts({String? category, String? subCategory, String? brandName}) {
    Query query = _db.collection('products');

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    if (subCategory != null && subCategory.isNotEmpty) {
      query = query.where('subCategory', isEqualTo: subCategory);
    }

    if (brandName != null && brandName.isNotEmpty) {
      query = query.where('brand_name', isEqualTo: brandName);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(
          doc.data() as Map<String, dynamic>,
          docId: doc.id,
        );
      }).toList();
    });
  }

  /// Compatibility method for older code
  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return getProducts(category: category);
  }

  /// Batch upload for migration
  Future<void> uploadBatchProducts(List<ProductModel> products) async {
    final batch = _db.batch();
    for (var product in products) {
      final docRef = _db.collection('products').doc();
      batch.set(docRef, product.toFirestore());
    }
    await batch.commit();
  }

  /// Placeholder for order creation
  Future<void> createOrder(dynamic order) async {
    if (order is OrderModel) {
      // Use the generated ID as the document ID for consistency
      final docId = order.id ?? _db.collection('orders').doc().id;
      await _db.collection('orders').doc(docId).set(order.toFirestore());
    } else if (order is Map<String, dynamic>) {
      await _db.collection('orders').add(order);
    } else {
      // Fallback for other objects that might have toMap or toJson
      try {
        await _db.collection('orders').add(order.toMap());
      } catch (_) {
        await _db.collection('orders').add(order.toJson());
      }
    }
  }

  /// Get a single product by ID
  Future<ProductModel?> getProductById(String id) async {
    final doc = await _db.collection('products').doc(id).get();
    if (doc.exists) {
      return ProductModel.fromMap(doc.data()!, docId: doc.id);
    }
    return null;
  }

  /// Get unique sub-categories for a specific category
  Future<List<String>> getSubCategories(String category) async {
    try {
      final snapshot = await _db
          .collection('products')
          .where('category', isEqualTo: category)
          .get();

      final Set<String> subCats = {};
      for (var doc in snapshot.docs) {
        final data = doc.data();
        if (data['subCategory'] != null && data['subCategory'].toString().isNotEmpty) {
          subCats.add(data['subCategory'].toString());
        }
      }
      return subCats.toList()..sort();
    } catch (e) {
      return [];
    }
  }

  /// Update user's wishlist in Firestore
  Future<void> updateUserWishlist(String uid, List<Map<String, dynamic>> items) async {
    try {
      await _db.collection('user').doc(uid).set({
        'wishlist': items,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint("✅ Wishlist synced to Firestore for user $uid");
    } catch (e) {
      debugPrint("❌ Error syncing wishlist to Firestore: $e");
    }
  }

  /// Update user's wallet cards in Firestore
  Future<void> updateUserCards(String uid, List<Map<String, dynamic>> cards) async {
    try {
      await _db.collection('user').doc(uid).set({
        'cards': cards,
        'cardsUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint("✅ Cards synced to Firestore for user $uid");
    } catch (e) {
      debugPrint("❌ Error syncing cards to Firestore: $e");
    }
  }

  /// Get user's wallet cards from Firestore
  Future<List<Map<String, dynamic>>> getUserCards(String uid) async {
    try {
      final doc = await _db.collection('user').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final data = doc.data()!;
        if (data['cards'] != null && data['cards'] is List) {
          return List<Map<String, dynamic>>.from(data['cards']);
        }
      }
      return [];
    } catch (e) {
      debugPrint("❌ Error fetching cards from Firestore: $e");
      return [];
    }
  }
}
