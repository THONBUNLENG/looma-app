import 'package:cloud_firestore/cloud_firestore.dart';
import '../../model/order_model.dart';
import '../../model/product_model.dart';

class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  factory FirestoreService() => _instance;
  FirestoreService._internal();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // --- Orders ---

  Future<void> createOrder(OrderModel order) async {
    try {
      await _db.collection('orders').add(order.toFirestore());
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Stream<List<OrderModel>> getOrders(String userId) {
    return _db
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList());
  }

  // --- Products ---

  /// Uploads a list of products in batches of 500 (Firestore limit).
  Future<void> uploadBatchProducts(List<ProductModel> products) async {
    final collection = _db.collection('products');
    
    // Split into chunks of 500
    for (var i = 0; i < products.length; i += 500) {
      final batch = _db.batch();
      final end = (i + 500 < products.length) ? i + 500 : products.length;
      final chunk = products.sublist(i, end);

      for (var product in chunk) {
        final docRef = collection.doc(); // Generate random ID
        batch.set(docRef, product.toFirestore());
      }

      await batch.commit();
      print('Uploaded batch of ${chunk.length} products (Total: $end)');
    }
  }

  Stream<List<ProductModel>> getProductsByCategory(String category) {
    return _db
        .collection('products')
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ProductModel.fromMap(doc.data(), docId: doc.id))
            .toList());
  }
}
