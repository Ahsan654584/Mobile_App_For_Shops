import 'package:flutter/material.dart';
import '../models/shop.dart';
import '../models/item.dart';
import '../models/order.dart';
import '../services/firestore_service.dart';
import '../services/sqlite_service.dart';
import '../utils/logger.dart';

/// Provider for managing shared application data
class DataProvider extends ChangeNotifier {
  final FirestoreService _firestoreService;
  final SQLiteService _sqliteService;

  List<Shop> _shops = [];
  List<Item> _items = [];
  List<Order> _orders = [];
  Shop? _selectedShop;
  bool _isLoading = false;
  String? _error;

  DataProvider({
    required FirestoreService firestoreService,
    required SQLiteService sqliteService,
  })  : _firestoreService = firestoreService,
        _sqliteService = sqliteService {
    _initialize();
  }

  void _initialize() {
    AppLogger.info('Initializing DataProvider');
  }

  /// Load all user shops
  Future<void> loadShops({required String userId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      AppLogger.info('Loading shops for user: $userId');

      // Try to get from Firestore first
      final shopsData = await _firestoreService.queryCollection(
        collectionName: 'shops',
      );

      _shops = shopsData
          .map((data) => Shop.fromJson({...data, 'id': data['id'] ?? ''}))
          .where((shop) => shop.ownerId == userId)
          .toList();

      AppLogger.info('Loaded ${_shops.length} shops');
    } catch (e) {
      _error = 'Failed to load shops: $e';
      AppLogger.error('Error loading shops', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create new shop
  Future<void> createShop({
    required String id,
    required String name,
    required String ownerId,
    required String address,
    String? city,
    String? state,
    String? postalCode,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      AppLogger.info('Creating shop: $name');

      final shop = Shop(
        id: id,
        name: name,
        ownerId: ownerId,
        address: address,
        city: city,
        state: state,
        postalCode: postalCode,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestoreService.createDocument(
        collectionName: 'shops',
        docId: id,
        data: shop.toJson(),
      );

      // Save to SQLite
      await _sqliteService.insert(
        table: 'shops_local',
        data: shop.toJson(),
      );

      _shops.add(shop);
      AppLogger.info('Shop created successfully: $name');
    } catch (e) {
      _error = 'Failed to create shop: $e';
      AppLogger.error('Error creating shop', e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update shop
  Future<void> updateShop(Shop shop) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      AppLogger.info('Updating shop: ${shop.name}');

      final updatedShop = shop.copyWith(updatedAt: DateTime.now());

      // Update in Firestore
      await _firestoreService.updateDocument(
        collectionName: 'shops',
        docId: shop.id,
        data: updatedShop.toJson(),
      );

      // Update in SQLite
      await _sqliteService.update(
        table: 'shops_local',
        data: updatedShop.toJson(),
        where: 'id = ?',
        whereArgs: [shop.id],
      );

      final index = _shops.indexWhere((s) => s.id == shop.id);
      if (index >= 0) {
        _shops[index] = updatedShop;
      }

      AppLogger.info('Shop updated successfully: ${shop.name}');
    } catch (e) {
      _error = 'Failed to update shop: $e';
      AppLogger.error('Error updating shop', e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete shop
  Future<void> deleteShop(String shopId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      AppLogger.info('Deleting shop: $shopId');

      // Delete from Firestore
      await _firestoreService.deleteDocument(
        collectionName: 'shops',
        docId: shopId,
      );

      // Delete from SQLite
      await _sqliteService.delete(
        table: 'shops_local',
        where: 'id = ?',
        whereArgs: [shopId],
      );

      _shops.removeWhere((shop) => shop.id == shopId);
      AppLogger.info('Shop deleted successfully: $shopId');
    } catch (e) {
      _error = 'Failed to delete shop: $e';
      AppLogger.error('Error deleting shop', e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load items for a shop
  Future<void> loadItems({required String shopId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      AppLogger.info('Loading items for shop: $shopId');

      final itemsData = await _firestoreService.queryCollection(
        collectionName: 'items',
      );

      _items = itemsData
          .map((data) => Item.fromJson({...data, 'id': data['id'] ?? ''}))
          .where((item) => item.shopId == shopId)
          .toList();

      AppLogger.info('Loaded ${_items.length} items');
    } catch (e) {
      _error = 'Failed to load items: $e';
      AppLogger.error('Error loading items', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create new item
  Future<void> createItem({
    required String id,
    required String name,
    required double price,
    required int quantity,
    required String shopId,
    String? description,
    String? category,
  }) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      AppLogger.info('Creating item: $name');

      final item = Item(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        shopId: shopId,
        description: description,
        category: category,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Save to Firestore
      await _firestoreService.createDocument(
        collectionName: 'items',
        docId: id,
        data: item.toJson(),
      );

      // Save to SQLite
      await _sqliteService.insert(
        table: 'items_local',
        data: item.toJson(),
      );

      _items.add(item);
      AppLogger.info('Item created successfully: $name');
    } catch (e) {
      _error = 'Failed to create item: $e';
      AppLogger.error('Error creating item', e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update item
  Future<void> updateItem(Item item) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      AppLogger.info('Updating item: ${item.name}');

      final updatedItem = item.copyWith(updatedAt: DateTime.now());

      // Update in Firestore
      await _firestoreService.updateDocument(
        collectionName: 'items',
        docId: item.id,
        data: updatedItem.toJson(),
      );

      // Update in SQLite
      await _sqliteService.update(
        table: 'items_local',
        data: updatedItem.toJson(),
        where: 'id = ?',
        whereArgs: [item.id],
      );

      final index = _items.indexWhere((i) => i.id == item.id);
      if (index >= 0) {
        _items[index] = updatedItem;
      }

      AppLogger.info('Item updated successfully: ${item.name}');
    } catch (e) {
      _error = 'Failed to update item: $e';
      AppLogger.error('Error updating item', e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Delete item
  Future<void> deleteItem(String itemId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      AppLogger.info('Deleting item: $itemId');

      // Delete from Firestore
      await _firestoreService.deleteDocument(
        collectionName: 'items',
        docId: itemId,
      );

      // Delete from SQLite
      await _sqliteService.delete(
        table: 'items_local',
        where: 'id = ?',
        whereArgs: [itemId],
      );

      _items.removeWhere((item) => item.id == itemId);
      AppLogger.info('Item deleted successfully: $itemId');
    } catch (e) {
      _error = 'Failed to delete item: $e';
      AppLogger.error('Error deleting item', e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Load orders
  Future<void> loadOrders({required String shopId}) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      AppLogger.info('Loading orders for shop: $shopId');

      final ordersData = await _firestoreService.queryCollection(
        collectionName: 'orders',
      );

      _orders = ordersData
          .map((data) => Order.fromJson({...data, 'id': data['id'] ?? ''}))
          .where((order) => order.shopId == shopId)
          .toList();

      _orders.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      AppLogger.info('Loaded ${_orders.length} orders');
    } catch (e) {
      _error = 'Failed to load orders: $e';
      AppLogger.error('Error loading orders', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create new order
  Future<void> createOrder(Order order) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      AppLogger.info('Creating order: ${order.id}');

      // Save to Firestore
      await _firestoreService.createDocument(
        collectionName: 'orders',
        docId: order.id,
        data: order.toJson(),
      );

      // Save to SQLite
      await _sqliteService.insert(
        table: 'orders_local',
        data: order.toJson(),
      );

      _orders.insert(0, order);
      AppLogger.info('Order created successfully: ${order.id}');
    } catch (e) {
      _error = 'Failed to create order: $e';
      AppLogger.error('Error creating order', e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update order status
  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      AppLogger.info('Updating order status: $orderId to ${status.name}');

      final orderIndex = _orders.indexWhere((o) => o.id == orderId);
      if (orderIndex < 0) return;

      final order = _orders[orderIndex];
      final updatedOrder = order.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );

      // Update in Firestore
      await _firestoreService.updateDocument(
        collectionName: 'orders',
        docId: orderId,
        data: updatedOrder.toJson(),
      );

      // Update in SQLite
      await _sqliteService.update(
        table: 'orders_local',
        data: updatedOrder.toJson(),
        where: 'id = ?',
        whereArgs: [orderId],
      );

      _orders[orderIndex] = updatedOrder;
      AppLogger.info('Order status updated: $orderId');
    } catch (e) {
      _error = 'Failed to update order: $e';
      AppLogger.error('Error updating order', e);
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Getters
  List<Shop> get shops => _shops;
  List<Item> get items => _items;
  List<Order> get orders => _orders;
  Shop? get selectedShop => _selectedShop;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setSelectedShop(Shop? shop) {
    _selectedShop = shop;
    notifyListeners();
  }
}
