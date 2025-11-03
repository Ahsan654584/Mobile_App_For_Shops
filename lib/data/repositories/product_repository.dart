import 'package:injectable/injectable.dart';
import '../../services/firebase_service.dart';
import '../../services/local_storage_service.dart';
import '../../core/utils/constants.dart';

@singleton
class ProductRepository {
  final FirebaseService _firebaseService;
  final LocalStorageService _localStorageService;

  ProductRepository(this._firebaseService, this._localStorageService);

  Future<Map<String, dynamic>?> getProductById(String productId) async {
    try {
      final productDoc = await _firebaseService.getDocument(
        AppConstants.productsCollection,
        productId,
      );

      if (!productDoc.exists) return null;

      return productDoc.data() as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllProducts() async {
    try {
      final productsSnapshot = await _firebaseService.getCollection(
        AppConstants.productsCollection,
      );

      return productsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getProductsByCategory(String category) async {
    try {
      final productsSnapshot = await _firebaseService.getCollection(
        AppConstants.productsCollection,
      );

      return productsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((product) => product['category'] == category)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<String?> createProduct(Map<String, dynamic> productData) async {
    try {
      final productId = _firebaseService.generateId();
      final productWithId = {
        ...productData,
        'id': productId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _firebaseService.setDocument(
        AppConstants.productsCollection,
        productId,
        productWithId,
      );

      return productId;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateProduct(String productId, Map<String, dynamic> updateData) async {
    try {
      final updateDataWithTimestamp = {
        ...updateData,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _firebaseService.updateDocument(
        AppConstants.productsCollection,
        productId,
        updateDataWithTimestamp,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteProduct(String productId) async {
    try {
      await _firebaseService.deleteDocument(
        AppConstants.productsCollection,
        productId,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> searchProducts(String query) async {
    try {
      final allProducts = await getAllProducts();

      return allProducts.where((product) {
        final name = (product['name'] as String).toLowerCase();
        final description = (product['description'] as String).toLowerCase();
        final category = (product['category'] as String).toLowerCase();
        final searchQuery = query.toLowerCase();

        return name.contains(searchQuery) ||
               description.contains(searchQuery) ||
               category.contains(searchQuery);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getLowStockProducts(int threshold) async {
    try {
      final allProducts = await getAllProducts();

      return allProducts.where((product) {
        final quantity = product['quantity'] as int? ?? 0;
        return quantity <= threshold;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getOutOfStockProducts() async {
    try {
      final allProducts = await getAllProducts();

      return allProducts.where((product) {
        final quantity = product['quantity'] as int? ?? 0;
        return quantity == 0;
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getFeaturedProducts({int limit = 10}) async {
    try {
      final productsSnapshot = await _firebaseService.getCollection(
        AppConstants.productsCollection,
        limit: limit,
        orderBy: 'createdAt',
        descending: true,
      );

      return productsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<String>> getCategories() async {
    try {
      final allProducts = await getAllProducts();
      final categories = allProducts
          .map((product) => product['category'] as String)
          .toSet()
          .toList();

      categories.sort();
      return categories;
    } catch (e) {
      return [];
    }
  }

  Future<bool> updateStock(String productId, int newQuantity) async {
    try {
      return await updateProduct(productId, {'quantity': newQuantity});
    } catch (e) {
      return false;
    }
  }

  Future<bool> decreaseStock(String productId, int quantity) async {
    try {
      final product = await getProductById(productId);
      if (product == null) return false;

      final currentQuantity = product['quantity'] as int? ?? 0;
      final newQuantity = currentQuantity - quantity;

      if (newQuantity < 0) return false;

      return await updateStock(productId, newQuantity);
    } catch (e) {
      return false;
    }
  }

  Future<bool> increaseStock(String productId, int quantity) async {
    try {
      final product = await getProductById(productId);
      if (product == null) return false;

      final currentQuantity = product['quantity'] as int? ?? 0;
      final newQuantity = currentQuantity + quantity;

      return await updateStock(productId, newQuantity);
    } catch (e) {
      return false;
    }
  }
}