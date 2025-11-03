import 'package:injectable/injectable.dart';
import '../../services/firebase_service.dart';
import '../../services/local_storage_service.dart';
import '../../core/utils/constants.dart';

@singleton
class OrderRepository {
  final FirebaseService _firebaseService;
  final LocalStorageService _localStorageService;

  OrderRepository(this._firebaseService, this._localStorageService);

  Future<Map<String, dynamic>?> getOrderById(String orderId) async {
    try {
      final orderDoc = await _firebaseService.getDocument(
        AppConstants.ordersCollection,
        orderId,
      );

      if (!orderDoc.exists) return null;

      return orderDoc.data() as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  Future<List<Map<String, dynamic>>> getAllOrders() async {
    try {
      final ordersSnapshot = await _firebaseService.getCollection(
        AppConstants.ordersCollection,
        orderBy: 'createdAt',
        descending: true,
      );

      return ordersSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getOrdersByCustomer(String customerId) async {
    try {
      final ordersSnapshot = await _firebaseService.getCollection(
        AppConstants.ordersCollection,
        orderBy: 'createdAt',
        descending: true,
      );

      return ordersSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((order) => order['customerId'] == customerId)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getOrdersByDistributor(String distributorId) async {
    try {
      final ordersSnapshot = await _firebaseService.getCollection(
        AppConstants.ordersCollection,
        orderBy: 'createdAt',
        descending: true,
      );

      return ordersSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((order) => order['distributorId'] == distributorId)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getOrdersByStatus(String status) async {
    try {
      final ordersSnapshot = await _firebaseService.getCollection(
        AppConstants.ordersCollection,
        orderBy: 'createdAt',
        descending: true,
      );

      return ordersSnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .where((order) => order['status'] == status)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<String?> createOrder(Map<String, dynamic> orderData) async {
    try {
      final orderId = _firebaseService.generateId();
      final orderWithId = {
        ...orderData,
        'id': orderId,
        'createdAt': DateTime.now().toIso8601String(),
        'updatedAt': DateTime.now().toIso8601String(),
        'status': AppConstants.pendingStatus,
      };

      await _firebaseService.setDocument(
        AppConstants.ordersCollection,
        orderId,
        orderWithId,
      );

      return orderId;
    } catch (e) {
      return null;
    }
  }

  Future<bool> updateOrder(String orderId, Map<String, dynamic> updateData) async {
    try {
      final updateDataWithTimestamp = {
        ...updateData,
        'updatedAt': DateTime.now().toIso8601String(),
      };

      await _firebaseService.updateDocument(
        AppConstants.ordersCollection,
        orderId,
        updateDataWithTimestamp,
      );

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateOrderStatus(String orderId, String newStatus) async {
    try {
      return await updateOrder(orderId, {'status': newStatus});
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteOrder(String orderId) async {
    try {
      await _firebaseService.deleteDocument(
        AppConstants.ordersCollection,
        orderId,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> searchOrders(String query) async {
    try {
      final allOrders = await getAllOrders();

      return allOrders.where((order) {
        final orderId = (order['id'] as String).toLowerCase();
        final customerId = (order['customerId'] as String).toLowerCase();
        final customerName = (order['customerName'] as String).toLowerCase();
        final searchQuery = query.toLowerCase();

        return orderId.contains(searchQuery) ||
               customerId.contains(searchQuery) ||
               customerName.contains(searchQuery);
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getPendingOrders() async {
    return await getOrdersByStatus(AppConstants.pendingStatus);
  }

  Future<List<Map<String, dynamic>>> getInTransitOrders() async {
    return await getOrdersByStatus(AppConstants.inTransitStatus);
  }

  Future<List<Map<String, dynamic>>> getDeliveredOrders() async {
    return await getOrdersByStatus(AppConstants.deliveredStatus);
  }

  Future<List<Map<String, dynamic>>> getCancelledOrders() async {
    return await getOrdersByStatus(AppConstants.cancelledStatus);
  }

  Future<List<Map<String, dynamic>>> getOrdersByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final allOrders = await getAllOrders();

      return allOrders.where((order) {
        final orderDate = DateTime.parse(order['createdAt'] as String);
        return orderDate.isAfter(startDate.subtract(const Duration(days: 1))) &&
               orderDate.isBefore(endDate.add(const Duration(days: 1)));
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<double> getTotalRevenue({DateTime? startDate, DateTime? endDate}) async {
    try {
      List<Map<String, dynamic>> orders;
      if (startDate != null && endDate != null) {
        orders = await getOrdersByDateRange(startDate, endDate);
      } else {
        orders = await getDeliveredOrders();
      }

      return orders.fold(0.0, (sum, order) {
        final totalAmount = order['totalAmount'] as double? ?? 0.0;
        return sum + totalAmount;
      });
    } catch (e) {
      return 0.0;
    }
  }

  Future<int> getOrderCount({String? status}) async {
    try {
      if (status != null) {
        final orders = await getOrdersByStatus(status);
        return orders.length;
      } else {
        final allOrders = await getAllOrders();
        return allOrders.length;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<Map<String, int>> getOrderStats() async {
    try {
      final pending = await getPendingOrders();
      final inTransit = await getInTransitOrders();
      final delivered = await getDeliveredOrders();
      final cancelled = await getCancelledOrders();

      return {
        'pending': pending.length,
        'inTransit': inTransit.length,
        'delivered': delivered.length,
        'cancelled': cancelled.length,
      };
    } catch (e) {
      return {
        'pending': 0,
        'inTransit': 0,
        'delivered': 0,
        'cancelled': 0,
      };
    }
  }
}