import 'package:intl/intl.dart';

/// Base model with common fields for all entities
abstract class BaseModel {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  BaseModel({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Convert model to JSON map (for storage/transmission)
  Map<String, dynamic> toJson() => {
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  /// Create model from JSON map
  static BaseModel fromJson(Map<String, dynamic> json) {
    throw UnimplementedError('Subclasses must implement fromJson');
  }

  /// Get formatted creation time
  String get formattedCreatedAt =>
      DateFormat('yyyy-MM-dd HH:mm').format(createdAt);

  /// Get formatted update time
  String get formattedUpdatedAt =>
      DateFormat('yyyy-MM-dd HH:mm').format(updatedAt);

  /// Compare models by ID and update time
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseModel && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
