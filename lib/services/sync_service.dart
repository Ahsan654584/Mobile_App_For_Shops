import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../core/error/exceptions.dart';
import '../core/utils/constants.dart';
import 'firebase_service.dart';
import 'local_storage_service.dart';

@singleton
class SyncService {
  final FirebaseService _firebaseService;
  final LocalStorageService _localStorageService;
  final Connectivity _connectivity = Connectivity();

  StreamSubscription? _connectivitySubscription;

  SyncService(this._firebaseService, this._localStorageService);

  Future<void> initialize() {
    // Initialize connectivity monitoring
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((result) {
      if (result != ConnectivityResult.none) {
        // When connectivity is restored, trigger sync
        _performBackgroundSync();
      }
    });

    return Future.value();
  }

  Future<void> dispose() async {
    await _connectivitySubscription?.cancel();
  }

  Future<bool> isOnline() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  Future<void> syncUserData() async {
    try {
      if (!await isOnline()) {
        throw const NetworkException.noConnection();
      }

      final userId = _firebaseService.currentUserId;
      if (userId == null) {
        throw const AuthException.unauthorized();
      }

      // Get latest user data from Firebase
      final userDoc = await _firebaseService.getDocument(
        AppConstants.usersCollection,
        userId,
      );

      if (userDoc.exists) {
        final userData = userDoc.data() as Map<String, dynamic>;
        await _localStorageService.saveUserSession(userData);
      }

      await _localStorageService.saveLastSyncTime();
    } catch (e) {
      throw CacheException.writeError('user_data_sync');
    }
  }

  Future<void> syncProducts() async {
    try {
      if (!await isOnline()) {
        throw const NetworkException.noConnection();
      }

      // Get products from Firebase
      final productsSnapshot = await _firebaseService.getCollection(
        AppConstants.productsCollection,
        limit: AppConstants.defaultPageSize,
      );

      final products = productsSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Cache products locally
      await _localStorageService.setJson(
        CacheKeys.productList,
        {'products': products, 'lastSync': DateTime.now().toIso8601String()},
      );

      await _localStorageService.saveLastSyncTime();
    } catch (e) {
      throw CacheException.writeError('products_sync');
    }
  }

  Future<void> syncOrders() async {
    try {
      if (!await isOnline()) {
        throw const NetworkException.noConnection();
      }

      final userId = _firebaseService.currentUserId;
      if (userId == null) {
        throw const AuthException.unauthorized();
      }

      // Get user's orders from Firebase
      final ordersQuery = _firebaseService.getCollection(
        AppConstants.ordersCollection,
        limit: AppConstants.defaultPageSize,
        orderBy: 'createdAt',
        descending: true,
      );

      final ordersSnapshot = await ordersQuery;
      final orders = ordersSnapshot.docs
          .where((doc) => doc.data()['customerId'] == userId)
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();

      // Cache orders locally
      await _localStorageService.setJson(
        CacheKeys.orderList,
        {'orders': orders, 'lastSync': DateTime.now().toIso8601String()},
      );

      await _localStorageService.saveLastSyncTime();
    } catch (e) {
      throw CacheException.writeError('orders_sync');
    }
  }

  Future<void> performFullSync() async {
    try {
      if (!await isOnline()) {
        throw const NetworkException.noConnection();
      }

      await syncUserData();
      await syncProducts();
      await syncOrders();

      // Clear expired cache
      await _localStorageService.clearExpiredCache();
    } catch (e) {
      throw CacheException.writeError('full_sync');
    }
  }

  Future<void> _performBackgroundSync() async {
    try {
      // Perform background sync without blocking UI
      await performFullSync();
    } catch (e) {
      // Log error but don't throw in background
      print('Background sync failed: $e');
    }
  }

  Future<DateTime?> getLastSyncTime() async {
    return _localStorageService.getLastSyncTime();
  }

  Future<bool> needsSync() async {
    final lastSync = await getLastSyncTime();
    if (lastSync == null) return true;

    final now = DateTime.now();
    final difference = now.difference(lastSync);

    // Sync if last sync was more than 1 hour ago
    return difference.inHours >= 1;
  }

  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map((result) {
      return result != ConnectivityResult.none;
    });
  }

  Future<void> forceSync() async {
    await performFullSync();
  }
}