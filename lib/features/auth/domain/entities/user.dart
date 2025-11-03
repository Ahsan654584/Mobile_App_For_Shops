import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String name;
  final String role;
  final String? phoneNumber;
  final String? photoURL;
  final bool isActive;
  final DateTime createdAt;
  final DateTime? lastLoginAt;
  final Map<String, dynamic>? additionalData;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
    this.phoneNumber,
    this.photoURL,
    this.isActive = true,
    required this.createdAt,
    this.lastLoginAt,
    this.additionalData,
  });

  @override
  List<Object?> get props => [
        id,
        email,
        name,
        role,
        phoneNumber,
        photoURL,
        isActive,
        createdAt,
        lastLoginAt,
        additionalData,
      ];

  User copyWith({
    String? id,
    String? email,
    String? name,
    String? role,
    String? phoneNumber,
    String? photoURL,
    bool? isActive,
    DateTime? createdAt,
    DateTime? lastLoginAt,
    Map<String, dynamic>? additionalData,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      role: role ?? this.role,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      photoURL: photoURL ?? this.photoURL,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      additionalData: additionalData ?? this.additionalData,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'role': role,
      if (phoneNumber != null) 'phoneNumber': phoneNumber,
      if (photoURL != null) 'photoURL': photoURL,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      if (lastLoginAt != null) 'lastLoginAt': lastLoginAt!.toIso8601String(),
      if (additionalData != null) 'additionalData': additionalData,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      email: json['email'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      phoneNumber: json['phoneNumber'] as String?,
      photoURL: json['photoURL'] as String?,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastLoginAt: json['lastLoginAt'] != null
          ? DateTime.parse(json['lastLoginAt'] as String)
          : null,
      additionalData: json['additionalData'] as Map<String, dynamic>?,
    );
  }

  // Convenience getters
  bool get isAdmin => role == 'admin';
  bool get isDistributor => role == 'distributor';
  bool get isCustomer => role == 'customer';

  bool get hasProfilePicture => photoURL != null && photoURL!.isNotEmpty;
  bool get hasPhoneNumber => phoneNumber != null && phoneNumber!.isNotEmpty;

  String get displayName => name.trim();
  String get displayEmail => email.trim();

  // Get user's full name with title based on role
  String get displayNameWithRole {
    switch (role) {
      case 'admin':
        return 'Admin - $name';
      case 'distributor':
        return 'Distributor - $name';
      case 'customer':
        return name;
      default:
        return name;
    }
  }

  // Get user initials for avatar
  String get initials {
    final names = name.trim().split(' ');
    if (names.length >= 2) {
      return '${names[0][0]}${names[1][0]}'.toUpperCase();
    } else {
      return name.isNotEmpty ? name[0].toUpperCase() : '';
    }
  }

  // Check if user has been active recently (within 30 days)
  bool get isActiveRecently {
    if (lastLoginAt == null) return false;
    final now = DateTime.now();
    final difference = now.difference(lastLoginAt!);
    return difference.inDays <= 30;
  }

  // Get user status as string
  String get status {
    if (!isActive) return 'Inactive';
    if (lastLoginAt == null) return 'Never Active';
    if (isActiveRecently) return 'Active';
    return 'Inactive';
  }

  @override
  String toString() {
    return 'User(id: $id, email: $email, name: $name, role: $role, isActive: $isActive)';
  }
}

// User extension for additional utility methods
extension UserExtension on User {
  // Get user permissions based on role
  List<String> get permissions {
    switch (role) {
      case 'admin':
        return [
          'read:products',
          'write:products',
          'delete:products',
          'read:orders',
          'write:orders',
          'delete:orders',
          'read:customers',
          'write:customers',
          'delete:customers',
          'read:distributors',
          'write:distributors',
          'delete:distributors',
          'read:analytics',
          'manage:users',
          'manage:system',
        ];
      case 'distributor':
        return [
          'read:products',
          'read:orders',
          'write:orders',
          'read:customers',
          'read:analytics',
        ];
      case 'customer':
        return [
          'read:products',
          'read:orders',
          'write:orders',
          'read:profile',
          'write:profile',
        ];
      default:
        return [];
    }
  }

  // Check if user has specific permission
  bool hasPermission(String permission) {
    return permissions.contains(permission);
  }

  // Check if user can access admin features
  bool get canAccessAdminFeatures => isAdmin;

  // Check if user can access distributor features
  bool get canAccessDistributorFeatures => isAdmin || isDistributor;

  // Check if user can access customer features
  bool get canAccessCustomerFeatures => isAdmin || isDistributor || isCustomer;

  // Get navigation items based on user role
  List<NavigationItem> get navigationItems {
    switch (role) {
      case 'admin':
        return [
          NavigationItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            route: '/admin/dashboard',
          ),
          NavigationItem(
            icon: Icons.inventory_2,
            label: 'Products',
            route: '/admin/products',
          ),
          NavigationItem(
            icon: Icons.receipt_long,
            label: 'Orders',
            route: '/admin/orders',
          ),
          NavigationItem(
            icon: Icons.people,
            label: 'Customers',
            route: '/admin/customers',
          ),
          NavigationItem(
            icon: Icons.local_shipping,
            label: 'Distributors',
            route: '/admin/distributors',
          ),
          NavigationItem(
            icon: Icons.analytics,
            label: 'Analytics',
            route: '/admin/analytics',
          ),
        ];
      case 'distributor':
        return [
          NavigationItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            route: '/distributor/dashboard',
          ),
          NavigationItem(
            icon: Icons.inventory_2,
            label: 'Products',
            route: '/distributor/products',
          ),
          NavigationItem(
            icon: Icons.receipt_long,
            label: 'Orders',
            route: '/distributor/orders',
          ),
          NavigationItem(
            icon: Icons.person,
            label: 'Profile',
            route: '/distributor/profile',
          ),
        ];
      case 'customer':
        return [
          NavigationItem(
            icon: Icons.dashboard,
            label: 'Dashboard',
            route: '/customer/dashboard',
          ),
          NavigationItem(
            icon: Icons.shopping_bag,
            label: 'Products',
            route: '/customer/products',
          ),
          NavigationItem(
            icon: Icons.receipt_long,
            label: 'Orders',
            route: '/customer/orders',
          ),
          NavigationItem(
            icon: Icons.person,
            label: 'Profile',
            route: '/customer/profile',
          ),
        ];
      default:
        return [];
    }
  }
}

class NavigationItem {
  final IconData icon;
  final String label;
  final String route;

  const NavigationItem({
    required this.icon,
    required this.label,
    required this.route,
  });
}