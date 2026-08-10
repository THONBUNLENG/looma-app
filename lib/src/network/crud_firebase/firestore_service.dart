import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import '../../model/order_model.dart';
import '../../model/product_model.dart';
import '../../model/user.dart';
import '../../telegarm_bot/bot_manager.dart';

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
      
      // Send Telegram notification
      await BotManager().sendOrderNotification(order);
    } else if (order is Map<String, dynamic>) {
      final docRef = await _db.collection('orders').add(order);
      
      // Attempt to send notification from Map if possible
      try {
        final orderObj = OrderModel.fromJson({...order, 'id': docRef.id});
        await BotManager().sendOrderNotification(orderObj);
      } catch (e) {
        debugPrint("Could not send Telegram notification for Map order: $e");
      }
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

  /// Update user's profile info in Firestore
  Future<void> updateUserInfo({
    required String uid,
    required String name,
    required String email,
    required String phone,
    required String address,
    String? gender,
    String? dateOfBirth,
    String? picture,
  }) async {
    try {
      await _db.collection('user').doc(uid).set({
        'name': name,
        'email': email,
        'phone': phone,
        'address': address,
        'gender': gender,
        'dateOfBirth': dateOfBirth,
        'photoUrl': picture, // Consistent with AuthLoginService
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint("✅ Profile info synced to Firestore for user $uid");
    } catch (e) {
      debugPrint("❌ Error syncing profile info to Firestore: $e");
    }
  }

  /// Update user's addresses in Firestore
  Future<void> updateUserAddresses(String uid, List<Map<String, dynamic>> addresses) async {
    try {
      await _db.collection('user').doc(uid).set({
        'addresses': addresses,
        'addressesUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint("✅ Addresses synced to Firestore for user $uid");
    } catch (e) {
      debugPrint("❌ Error syncing addresses to Firestore: $e");
    }
  }

  /// Get user's profile data from Firestore
  Future<UserModel?> getUserProfile(String uid) async {
    try {
      final doc = await _db.collection('user').doc(uid).get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromJson(doc.id, doc.data()!);
      }
      return null;
    } catch (e) {
      debugPrint("❌ Error fetching user profile from Firestore: $e");
      return null;
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

  /// Get Telegram Admin Chat ID
  Future<int?> getTelegramAdminChatId() async {
    try {
      final doc = await _db.collection('configs').doc('telegram').get();
      if (doc.exists && doc.data() != null) {
        return doc.data()!['adminChatId'] as int?;
      }
    } catch (e) {
      debugPrint("❌ Error fetching Telegram Admin ID: $e");
    }
    return null;
  }

  /// Save Telegram Admin Chat ID
  Future<void> saveTelegramAdminChatId(int chatId) async {
    try {
      await _db.collection('configs').doc('telegram').set({
        'adminChatId': chatId,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      debugPrint("✅ Telegram Admin ID saved: $chatId");
    } catch (e) {
      debugPrint("❌ Error saving Telegram Admin ID: $e");
    }
  }
}
