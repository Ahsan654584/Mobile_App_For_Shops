import 'base_model.dart';

/// User model representing an authenticated user
class User extends BaseModel {
  final String email;
  final String displayName;
  final String? profilePictureUrl;
  final bool isEmailVerified;
  final String? phoneNumber;
  final List<String> shopIds;

  User({
    required String id,
    required this.email,
    required this.displayName,
    required DateTime createdAt,
    required DateTime updatedAt,
    this.profilePictureUrl,
    this.isEmailVerified = false,
    this.phoneNumber,
    List<String>? shopIds,
  })  : shopIds = shopIds ?? [],
        super(id: id, createdAt: createdAt, updatedAt: updatedAt);

  @override
  Map<String, dynamic> toJson() => {
        ...super.toJson(),
        'email': email,
        'displayName': displayName,
        'profilePictureUrl': profilePictureUrl,
        'isEmailVerified': isEmailVerified,
        'phoneNumber': phoneNumber,
        'shopIds': shopIds,
      };

  /// Create User from JSON
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      profilePictureUrl: json['profilePictureUrl'] as String?,
      isEmailVerified: json['isEmailVerified'] as bool? ?? false,
      phoneNumber: json['phoneNumber'] as String?,
      shopIds: List<String>.from(json['shopIds'] as List? ?? []),
    );
  }

  /// Create a copy of User with optional field updates
  User copyWith({
    String? id,
    String? email,
    String? displayName,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? profilePictureUrl,
    bool? isEmailVerified,
    String? phoneNumber,
    List<String>? shopIds,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      shopIds: shopIds ?? this.shopIds,
    );
  }
}
