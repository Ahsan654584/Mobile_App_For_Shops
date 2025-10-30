import 'base_model.dart';

/// Item/Product model
class Item extends BaseModel {
  final String name;
  final String? description;
  final double price;
  final int quantity;
  final String shopId;
  final String? category;
  final String? sku;
  final bool isActive;

  Item({
    required String id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.shopId,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.description,
    this.category,
    this.sku,
    this.isActive = true,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'name': name,
        'description': description,
        'price': price,
        'quantity': quantity,
        'shopId': shopId,
        'category': category,
        'sku': sku,
        'isActive': isActive,
      };

  /// Create Item from JSON
  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      shopId: json['shopId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      description: json['description'] as String?,
      category: json['category'] as String?,
      sku: json['sku'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Get total value (price * quantity)
  double get totalValue => price * quantity;

  /// Get formatted price
  String get formattedPrice => '\$${price.toStringAsFixed(2)}';

  /// Create a copy of Item with optional field updates
  Item copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? quantity,
    String? shopId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? category,
    String? sku,
    bool? isActive,
  }) {
    return Item(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      shopId: shopId ?? this.shopId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      description: description ?? this.description,
      category: category ?? this.category,
      sku: sku ?? this.sku,
      isActive: isActive ?? this.isActive,
    );
  }
}
