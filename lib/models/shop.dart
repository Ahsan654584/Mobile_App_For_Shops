import 'base_model.dart';

/// Shop model representing a store or business
class Shop extends BaseModel {
  final String name;
  final String ownerId;
  final String address;
  final String? city;
  final String? state;
  final String? postalCode;
  final String? phone;
  final String? email;
  final String? website;
  final bool isActive;

  Shop({
    required String id,
    required this.name,
    required this.ownerId,
    required this.address,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.city,
    this.state,
    this.postalCode,
    this.phone,
    this.email,
    this.website,
    this.isActive = true,
  }) : super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'name': name,
        'ownerId': ownerId,
        'address': address,
        'city': city,
        'state': state,
        'postalCode': postalCode,
        'phone': phone,
        'email': email,
        'website': website,
        'isActive': isActive,
      };

  /// Create Shop from JSON
  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'] as String,
      name: json['name'] as String,
      ownerId: json['ownerId'] as String,
      address: json['address'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      city: json['city'] as String?,
      state: json['state'] as String?,
      postalCode: json['postalCode'] as String?,
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      isActive: json['isActive'] as bool? ?? true,
    );
  }

  /// Get full address
  String get fullAddress {
    final parts = [address];
    if (city != null) parts.add(city!);
    if (state != null) parts.add(state!);
    if (postalCode != null) parts.add(postalCode!);
    return parts.join(', ');
  }

  /// Create a copy of Shop with optional field updates
  Shop copyWith({
    String? id,
    String? name,
    String? ownerId,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? city,
    String? state,
    String? postalCode,
    String? phone,
    String? email,
    String? website,
    bool? isActive,
  }) {
    return Shop(
      id: id ?? this.id,
      name: name ?? this.name,
      ownerId: ownerId ?? this.ownerId,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      city: city ?? this.city,
      state: state ?? this.state,
      postalCode: postalCode ?? this.postalCode,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      isActive: isActive ?? this.isActive,
    );
  }
}
