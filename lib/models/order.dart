import 'base_model.dart';

/// Order status enum
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
}

/// Order item in an order
class OrderItem {
  final String itemId;
  final String itemName;
  final int quantity;
  final double price;

  OrderItem({
    required this.itemId,
    required this.itemName,
    required this.quantity,
    required this.price,
  });

  Map<String, dynamic> toJson() => {
        'itemId': itemId,
        'itemName': itemName,
        'quantity': quantity,
        'price': price,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      itemId: json['itemId'] as String,
      itemName: json['itemName'] as String,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  double get subtotal => quantity * price;
}

/// Order model
class Order extends BaseModel {
  final String shopId;
  final String userId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final String? notes;
  final String? customerName;
  final String? customerEmail;
  final String? customerPhone;
  final String? deliveryAddress;

  Order({
    required String id,
    required this.shopId,
    required this.userId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.notes,
    this.customerName,
    this.customerEmail,
    this.customerPhone,
    this.deliveryAddress,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'shopId': shopId,
        'userId': userId,
        'items': items.map((item) => item.toJson()).toList(),
        'totalAmount': totalAmount,
        'status': status.name,
        'notes': notes,
        'customerName': customerName,
        'customerEmail': customerEmail,
        'customerPhone': customerPhone,
        'deliveryAddress': deliveryAddress,
      };

  /// Create Order from JSON
  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'] as String,
      shopId: json['shopId'] as String,
      userId: json['userId'] as String,
      items: (json['items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: OrderStatus.values.firstWhere(
        (status) => status.name == (json['status'] as String?),
        orElse: () => OrderStatus.pending,
      ),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      notes: json['notes'] as String?,
      customerName: json['customerName'] as String?,
      customerEmail: json['customerEmail'] as String?,
      customerPhone: json['customerPhone'] as String?,
      deliveryAddress: json['deliveryAddress'] as String?,
    );
  }

  /// Get item count
  int get itemCount => items.fold(0, (sum, item) => sum + item.quantity);

  /// Get status display text
  String get statusText => status.name.replaceFirst(
        status.name[0],
        status.name[0].toUpperCase(),
      );

  /// Get status color
  String get statusColor {
    switch (status) {
      case OrderStatus.pending:
        return '#FFA500'; // Orange
      case OrderStatus.confirmed:
        return '#3B82F6'; // Blue
      case OrderStatus.processing:
        return '#8B5CF6'; // Purple
      case OrderStatus.shipped:
        return '#10B981'; // Green
      case OrderStatus.delivered:
        return '#059669'; // Dark Green
      case OrderStatus.cancelled:
        return '#EF4444'; // Red
    }
  }

  /// Create a copy of Order with optional field updates
  Order copyWith({
    String? id,
    String? shopId,
    String? userId,
    List<OrderItem>? items,
    double? totalAmount,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? notes,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? deliveryAddress,
  }) {
    return Order(
      id: id ?? this.id,
      shopId: shopId ?? this.shopId,
      userId: userId ?? this.userId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      notes: notes ?? this.notes,
      customerName: customerName ?? this.customerName,
      customerEmail: customerEmail ?? this.customerEmail,
      customerPhone: customerPhone ?? this.customerPhone,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
    );
  }
}
