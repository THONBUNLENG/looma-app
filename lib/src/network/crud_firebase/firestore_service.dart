import 'package:cloud_firestore/cloud_firestore.dart';
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
    await _db.collection('orders').add(order.toMap());
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
}
