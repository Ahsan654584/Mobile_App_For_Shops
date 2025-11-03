import 'package:equatable/equatable.dart';

/// Base failure class for all application failures
abstract class Failure extends Equatable {
  final String message;
  final String? code;
  final dynamic details;

  const Failure(
    this.message, {
    this.code,
    this.details,
  });

  @override
  List<Object?> get props => [message, code, details];

  @override
  String toString() => 'Failure: $message';
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure(
    super.message, {
    super.code,
    super.details,
  });

  factory ServerFailure.connectionError() {
    return const ServerFailure(
      'Failed to connect to the server. Please check your internet connection.',
      code: 'CONNECTION_ERROR',
    );
  }

  factory ServerFailure.internalServerError() {
    return const ServerFailure(
      'Internal server error. Please try again later.',
      code: 'INTERNAL_SERVER_ERROR',
    );
  }

  factory ServerFailure.serviceUnavailable() {
    return const ServerFailure(
      'Service is temporarily unavailable. Please try again later.',
      code: 'SERVICE_UNAVAILABLE',
    );
  }

  factory ServerFailure.badRequest() {
    return const ServerFailure(
      'Invalid request. Please check your input and try again.',
      code: 'BAD_REQUEST',
    );
  }

  factory ServerFailure.notFound() {
    return const ServerFailure(
      'The requested resource was not found.',
      code: 'NOT_FOUND',
    );
  }

  factory ServerFailure.timeout() {
    return const ServerFailure(
      'Request timed out. Please try again.',
      code: 'TIMEOUT',
    );
  }

  factory ServerFailure.unknown() {
    return const ServerFailure(
      'An unknown server error occurred.',
      code: 'UNKNOWN',
    );
  }
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure(
    super.message, {
    super.code,
    super.details,
  });

  factory NetworkFailure.noConnection() {
    return const NetworkFailure(
      'No internet connection. Please check your network settings.',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      'Network request timed out. Please try again.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkFailure.serverUnavailable() {
    return const NetworkFailure(
      'Server is temporarily unavailable. Please try again later.',
      code: 'SERVER_UNAVAILABLE',
    );
  }

  factory NetworkFailure.unknown() {
    return const NetworkFailure(
      'An unknown network error occurred.',
      code: 'UNKNOWN',
    );
  }
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure(
    super.message, {
    super.code,
    super.details,
  });

  factory AuthFailure.invalidCredentials() {
    return const AuthFailure(
      'Invalid email or password.',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthFailure.userNotFound() {
    return const AuthFailure(
      'User account not found.',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthFailure.emailAlreadyInUse() {
    return const AuthFailure(
      'Email address is already in use.',
      code: 'EMAIL_ALREADY_IN_USE',
    );
  }

  factory AuthFailure.weakPassword() {
    return const AuthFailure(
      'Password is too weak. Please choose a stronger password.',
      code: 'WEAK_PASSWORD',
    );
  }

  factory AuthFailure.sessionExpired() {
    return const AuthFailure(
      'Your session has expired. Please login again.',
      code: 'SESSION_EXPIRED',
    );
  }

  factory AuthFailure.unauthorized() {
    return const AuthFailure(
      'You are not authorized to perform this action.',
      code: 'UNAUTHORIZED',
    );
  }

  factory AuthFailure.forbidden() {
    return const AuthFailure(
      'Access denied. You do not have permission to access this resource.',
      code: 'FORBIDDEN',
    );
  }

  factory AuthFailure.accountDisabled() {
    return const AuthFailure(
      'Your account has been disabled. Please contact support.',
      code: 'ACCOUNT_DISABLED',
    );
  }

  factory AuthFailure.tooManyAttempts() {
    return const AuthFailure(
      'Too many failed login attempts. Please try again later.',
      code: 'TOO_MANY_ATTEMPTS',
    );
  }

  factory AuthFailure.tokenInvalid() {
    return const AuthFailure(
      'Invalid authentication token.',
      code: 'TOKEN_INVALID',
    );
  }

  factory AuthFailure.tokenExpired() {
    return const AuthFailure(
      'Authentication token has expired.',
      code: 'TOKEN_EXPIRED',
    );
  }
}

/// Validation failures
class ValidationFailure extends Failure {
  final Map<String, String>? fieldErrors;

  const ValidationFailure(
    super.message, {
    super.code,
    super.details,
    this.fieldErrors,
  });

  factory ValidationFailure.invalidEmail() {
    return const ValidationFailure(
      'Please enter a valid email address.',
      code: 'INVALID_EMAIL',
    );
  }

  factory ValidationFailure.invalidPassword() {
    return const ValidationFailure(
      'Password must be at least 6 characters long and contain at least one letter and one number.',
      code: 'INVALID_PASSWORD',
    );
  }

  factory ValidationFailure.passwordMismatch() {
    return const ValidationFailure(
      'Passwords do not match.',
      code: 'PASSWORD_MISMATCH',
    );
  }

  factory ValidationFailure.requiredField(String fieldName) {
    return ValidationFailure(
      '$fieldName is required.',
      code: 'REQUIRED_FIELD',
      details: {'fieldName': fieldName},
    );
  }

  factory ValidationFailure.invalidFormat(String fieldName) {
    return ValidationFailure(
      'Invalid $fieldName format.',
      code: 'INVALID_FORMAT',
      details: {'fieldName': fieldName},
    );
  }

  factory ValidationFailure.invalidLength(String fieldName, int minLength, int maxLength) {
    return ValidationFailure(
      '$fieldName must be between $minLength and $maxLength characters.',
      code: 'INVALID_LENGTH',
      details: {
        'fieldName': fieldName,
        'minLength': minLength,
        'maxLength': maxLength,
      },
    );
  }

  factory ValidationFailure.invalidRange(String fieldName, dynamic min, dynamic max) {
    return ValidationFailure(
      '$fieldName must be between $min and $max.',
      code: 'INVALID_RANGE',
      details: {'fieldName': fieldName, 'min': min, 'max': max},
    );
  }

  factory ValidationFailure.custom(String message, {String? code}) {
    return ValidationFailure(
      message,
      code: code ?? 'CUSTOM_VALIDATION',
    );
  }
}

/// Firebase failures
class FirebaseFailure extends Failure {
  const FirebaseFailure(
    super.message, {
    super.code,
    super.details,
  });

  factory FirebaseFailure.documentNotFound(String documentPath) {
    return FirebaseFailure(
      'Document not found: $documentPath',
      code: 'DOCUMENT_NOT_FOUND',
      details: {'documentPath': documentPath},
    );
  }

  factory FirebaseFailure.permissionDenied(String operation) {
    return FirebaseFailure(
      'Permission denied for operation: $operation',
      code: 'PERMISSION_DENIED',
      details: {'operation': operation},
    );
  }

  factory FirebaseFailure.unavailable() {
    return const FirebaseFailure(
      'Firebase service is currently unavailable.',
      code: 'SERVICE_UNAVAILABLE',
    );
  }

  factory FirebaseFailure.deadlineExceeded() {
    return const FirebaseFailure(
      'Firebase operation deadline exceeded.',
      code: 'DEADLINE_EXCEEDED',
    );
  }

  factory FirebaseFailure.quotaExceeded() {
    return const FirebaseFailure(
      'Firebase quota has been exceeded.',
      code: 'QUOTA_EXCEEDED',
    );
  }

  factory FirebaseFailure.cancelled() {
    return const FirebaseFailure(
      'Firebase operation was cancelled.',
      code: 'CANCELLED',
    );
  }

  factory FirebaseFailure.dataLoss() {
    return const FirebaseFailure(
      'Unrecoverable data loss or corruption.',
      code: 'DATA_LOSS',
    );
  }

  factory FirebaseFailure.unknown() {
    return const FirebaseFailure(
      'An unknown Firebase error occurred.',
      code: 'UNKNOWN',
    );
  }
}

/// Storage failures
class StorageFailure extends Failure {
  const StorageFailure(
    super.message, {
    super.code,
    super.details,
  });

  factory StorageFailure.fileTooLarge(int maxSizeMB) {
    return StorageFailure(
      'File size exceeds the maximum allowed size of ${maxSizeMB}MB.',
      code: 'FILE_TOO_LARGE',
      details: {'maxSizeMB': maxSizeMB},
    );
  }

  factory StorageFailure.invalidFileType(List<String> allowedTypes) {
    return StorageFailure(
      'Invalid file type. Allowed types: ${allowedTypes.join(', ')}',
      code: 'INVALID_FILE_TYPE',
      details: {'allowedTypes': allowedTypes},
    );
  }

  factory StorageFailure.uploadFailed() {
    return const StorageFailure(
      'Failed to upload file. Please try again.',
      code: 'UPLOAD_FAILED',
    );
  }

  factory StorageFailure.downloadFailed() {
    return const StorageFailure(
      'Failed to download file. Please try again.',
      code: 'DOWNLOAD_FAILED',
    );
  }

  factory StorageFailure.quotaExceeded() {
    return const StorageFailure(
      'Storage quota exceeded. Please free up some space.',
      code: 'QUOTA_EXCEEDED',
    );
  }

  factory StorageFailure.fileNotFound() {
    return const StorageFailure(
      'The requested file was not found.',
      code: 'FILE_NOT_FOUND',
    );
  }
}

/// Cache failures
class CacheFailure extends Failure {
  const CacheFailure(
    super.message, {
    super.code,
    super.details,
  });

  factory CacheFailure.notFound(String key) {
    return CacheFailure(
      'Cache item not found: $key',
      code: 'CACHE_NOT_FOUND',
      details: {'key': key},
    );
  }

  factory CacheFailure.writeError(String key) {
    return CacheFailure(
      'Failed to write to cache: $key',
      code: 'CACHE_WRITE_ERROR',
      details: {'key': key},
    );
  }

  factory CacheFailure.readError(String key) {
    return CacheFailure(
      'Failed to read from cache: $key',
      code: 'CACHE_READ_ERROR',
      details: {'key': key},
    );
  }

  factory CacheFailure.corruptedData(String key) {
    return CacheFailure(
      'Corrupted cache data: $key',
      code: 'CORRUPTED_DATA',
      details: {'key': key},
    );
  }

  factory CacheFailure.full() {
    return const CacheFailure(
      'Cache is full. Please clear some data.',
      code: 'CACHE_FULL',
    );
  }
}

/// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure(
    super.message, {
    super.code,
    super.details,
  });

  factory PermissionFailure.cameraDenied() {
    return const PermissionFailure(
      'Camera permission is required to take photos.',
      code: 'CAMERA_DENIED',
    );
  }

  factory PermissionFailure.storageDenied() {
    return const PermissionFailure(
      'Storage permission is required to save files.',
      code: 'STORAGE_DENIED',
    );
  }

  factory PermissionFailure.photosDenied() {
    return const PermissionFailure(
      'Photos permission is required to access your photo library.',
      code: 'PHOTOS_DENIED',
    );
  }

  factory PermissionFailure.microphoneDenied() {
    return const PermissionFailure(
      'Microphone permission is required for audio features.',
      code: 'MICROPHONE_DENIED',
    );
  }

  factory PermissionFailure.locationDenied() {
    return const PermissionFailure(
      'Location permission is required for location features.',
      code: 'LOCATION_DENIED',
    );
  }

  factory PermissionFailure.permanentlyDenied(String permission) {
    return PermissionFailure(
      '$permission permission was permanently denied. Please enable it in settings.',
      code: 'PERMANENTLY_DENIED',
      details: {'permission': permission},
    );
  }
}

/// Business logic failures
class BusinessFailure extends Failure {
  const BusinessFailure(
    super.message, {
    super.code,
    super.details,
  });

  factory BusinessFailure.insufficientStock(String productName, int available) {
    return BusinessFailure(
      'Insufficient stock for $productName. Available: $available',
      code: 'INSUFFICIENT_STOCK',
      details: {'productName': productName, 'available': available},
    );
  }

  factory BusinessFailure.productNotFound(String productName) {
    return BusinessFailure(
      'Product not found: $productName',
      code: 'PRODUCT_NOT_FOUND',
      details: {'productName': productName},
    );
  }

  factory BusinessFailure.orderNotFound(String orderId) {
    return BusinessFailure(
      'Order not found: $orderId',
      code: 'ORDER_NOT_FOUND',
      details: {'orderId': orderId},
    );
  }

  factory BusinessFailure.invalidOrderStatus(String currentStatus, String requiredStatus) {
    return BusinessFailure(
      'Cannot update order. Current status: $currentStatus, Required: $requiredStatus',
      code: 'INVALID_ORDER_STATUS',
      details: {
        'currentStatus': currentStatus,
        'requiredStatus': requiredStatus,
      },
    );
  }

  factory BusinessFailure.duplicateEntry(String field, String value) {
    return BusinessFailure(
      'A record with this $field already exists: $value',
      code: 'DUPLICATE_ENTRY',
      details: {'field': field, 'value': value},
    );
  }

  factory BusinessFailure.lowStock(String productName, int currentStock, int minStock) {
    return BusinessFailure(
      'Low stock warning for $productName. Current: $currentStock, Minimum: $minStock',
      code: 'LOW_STOCK',
      details: {
        'productName': productName,
        'currentStock': currentStock,
        'minStock': minStock,
      },
    );
  }

  factory BusinessFailure.outOfStock(String productName) {
    return BusinessFailure(
      'Product is out of stock: $productName',
      code: 'OUT_OF_STOCK',
      details: {'productName': productName},
    );
  }
}

/// Unknown failure for unexpected errors
class UnknownFailure extends Failure {
  const UnknownFailure(
    super.message, {
    super.code,
    super.details,
  });

  factory UnknownFailure.unexpected([String? message]) {
    return UnknownFailure(
      message ?? 'An unexpected error occurred.',
      code: 'UNEXPECTED',
    );
  }
}