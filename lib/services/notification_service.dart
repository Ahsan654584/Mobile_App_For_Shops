import 'dart:async';
import 'package:injectable/injectable.dart';
import '../core/utils/constants.dart';
import 'local_storage_service.dart';

@singleton
class NotificationService {
  final LocalStorageService _localStorageService;

  NotificationService(this._localStorageService);

  Future<void> initialize() async {
    // Initialize notification service
    // This would typically involve initializing Firebase Cloud Messaging
    // or local notification plugin
  }

  Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
    NotificationType type = NotificationType.info,
  }) async {
    // Save notification locally
    final notification = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': title,
      'body': body,
      'payload': payload,
      'type': type.name,
      'timestamp': DateTime.now().toIso8601String(),
      'read': false,
    };

    await _saveNotification(notification);

    // Show local notification (this would use a notification plugin)
    // For now, we'll just print the notification
    print('Notification: $title - $body');
  }

  Future<void> showOrderNotification({
    required String orderId,
    required String status,
    String? customerName,
  }) async {
    final title = 'Order Update';
    final body = 'Order $orderId is now $status';
    if (customerName != null) {
      await showNotification(
        title: title,
        body: '$body for $customerName',
        payload: orderId,
        type: NotificationType.order,
      );
    } else {
      await showNotification(
        title: title,
        body: body,
        payload: orderId,
        type: NotificationType.order,
      );
    }
  }

  Future<void> showLowStockNotification({
    required String productName,
    required int currentStock,
    required int minStock,
  }) async {
    await showNotification(
      title: 'Low Stock Alert',
      body: '$productName is running low. Current: $currentStock, Min: $minStock',
      type: NotificationType.stock,
    );
  }

  Future<void> showNewOrderNotification({
    required String orderId,
    required String customerName,
    required double amount,
  }) async {
    await showNotification(
      title: 'New Order',
      body: 'Order $orderId from $customerName for ${AppHelpers.formatCurrency(amount)}',
      payload: orderId,
      type: NotificationType.order,
    );
  }

  Future<void> showPaymentNotification({
    required String orderId,
    required double amount,
    required String paymentType,
  }) async {
    await showNotification(
      title: 'Payment Received',
      body: '$paymentType payment of ${AppHelpers.formatCurrency(amount)} received for order $orderId',
      payload: orderId,
      type: NotificationType.payment,
    );
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    try {
      final notificationsJson = _localStorageService.getJson('notifications');
      if (notificationsJson == null) return [];

      final notifications = notificationsJson['notifications'] as List<dynamic>? ?? [];
      return notifications.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getUnreadNotifications() async {
    final notifications = await getNotifications();
    return notifications.where((notification) => notification['read'] == false).toList();
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    final notifications = await getNotifications();
    final updatedNotifications = notifications.map((notification) {
      if (notification['id'] == notificationId) {
        final updated = Map<String, dynamic>.from(notification);
        updated['read'] = true;
        return updated;
      }
      return notification;
    }).toList();

    await _saveNotificationsList(updatedNotifications);
  }

  Future<void> markAllNotificationsAsRead() async {
    final notifications = await getNotifications();
    final updatedNotifications = notifications.map((notification) {
      final updated = Map<String, dynamic>.from(notification);
      updated['read'] = true;
      return updated;
    }).toList();

    await _saveNotificationsList(updatedNotifications);
  }

  Future<void> deleteNotification(String notificationId) async {
    final notifications = await getNotifications();
    final updatedNotifications = notifications
        .where((notification) => notification['id'] != notificationId)
        .toList();

    await _saveNotificationsList(updatedNotifications);
  }

  Future<void> clearAllNotifications() async {
    await _localStorageService.remove('notifications');
  }

  Future<int> getUnreadCount() async {
    final unreadNotifications = await getUnreadNotifications();
    return unreadNotifications.length;
  }

  Future<void> _saveNotification(Map<String, dynamic> notification) async {
    final notifications = await getNotifications();
    notifications.insert(0, notification);

    // Keep only last 100 notifications
    if (notifications.length > 100) {
      notifications.removeRange(100, notifications.length);
    }

    await _saveNotificationsList(notifications);
  }

  Future<void> _saveNotificationsList(List<Map<String, dynamic>> notifications) async {
    await _localStorageService.setJson('notifications', {
      'notifications': notifications,
      'lastUpdated': DateTime.now().toIso8601String(),
    });
  }

  // Notification settings
  Future<bool> areNotificationsEnabled() async {
    return _localStorageService.getBool('notifications_enabled') ?? true;
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    await _localStorageService.setBool('notifications_enabled', enabled);
  }

  Future<bool> areOrderNotificationsEnabled() async {
    return _localStorageService.getBool('order_notifications_enabled') ?? true;
  }

  Future<void> setOrderNotificationsEnabled(bool enabled) async {
    await _localStorageService.setBool('order_notifications_enabled', enabled);
  }

  Future<bool> areStockNotificationsEnabled() async {
    return _localStorageService.getBool('stock_notifications_enabled') ?? true;
  }

  Future<void> setStockNotificationsEnabled(bool enabled) async {
    await _localStorageService.setBool('stock_notifications_enabled', enabled);
  }

  Future<bool> arePaymentNotificationsEnabled() async {
    return _localStorageService.getBool('payment_notifications_enabled') ?? true;
  }

  Future<void> setPaymentNotificationsEnabled(bool enabled) async {
    await _localStorageService.setBool('payment_notifications_enabled', enabled);
  }
}

enum NotificationType {
  info,
  success,
  warning,
  error,
  order,
  stock,
  payment,
  system,
}

// Helper extension for AppHelpers reference
class AppHelpers {
  static String formatCurrency(double amount, {String symbol = '\$'}) {
    return '$symbol${amount.toStringAsFixed(2)}';
  }
}