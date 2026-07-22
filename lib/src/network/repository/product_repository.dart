import '../../model/product_model.dart';
import '../crud_firebase/firestore_service.dart';

class ProductRepository {
  final FirestoreService _firestoreService = FirestoreService();

  Future<List<ProductModel>> getProductsByCategory(String category) async {
    try {
      return _firestoreService.getProductsByCategory(category).first;
    } catch (e) {
      throw Exception('Failed to fetch products: $e');
    }
  }

  Stream<List<ProductModel>> getProductsStream(String category) {
    return _firestoreService.getProductsByCategory(category);
  }

  /// Search products in Firestore (Note: Simple string matching)
  Future<List<ProductModel>> searchProducts(String query) async {

    return [];
  }
}
