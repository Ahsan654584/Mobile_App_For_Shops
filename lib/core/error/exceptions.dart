/// Base exception class for all custom exceptions
abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic details;

  const AppException(
    this.message, {
    this.code,
    this.details,
  });

  @override
  String toString() => 'AppException: $message';
}

/// Server-related exceptions
class ServerException extends AppException {
  const ServerException(
    super.message, {
    super.code,
    super.details,
  });

  factory ServerException.fromResponse(int statusCode, Map<String, dynamic> response) {
    return ServerException(
      response['message'] ?? 'Server error occurred',
      code: response['code']?.toString(),
      details: response,
    );
  }
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException(
    super.message, {
    super.code,
    super.details,
  });

  factory NetworkException.noConnection() {
    return const NetworkException(
      'No internet connection. Please check your network settings.',
      code: 'NO_CONNECTION',
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      'Request timed out. Please try again.',
      code: 'TIMEOUT',
    );
  }

  factory NetworkException.serverUnavailable() {
    return const NetworkException(
      'Server is temporarily unavailable. Please try again later.',
      code: 'SERVER_UNAVAILABLE',
    );
  }
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException(
    super.message, {
    super.code,
    super.details,
  });

  factory AuthException.invalidCredentials() {
    return const AuthException(
      'Invalid email or password',
      code: 'INVALID_CREDENTIALS',
    );
  }

  factory AuthException.userNotFound() {
    return const AuthException(
      'User not found',
      code: 'USER_NOT_FOUND',
    );
  }

  factory AuthException.emailAlreadyInUse() {
    return const AuthException(
      'Email is already in use',
      code: 'EMAIL_ALREADY_IN_USE',
    );
  }

  factory AuthException.weakPassword() {
    return const AuthException(
      'Password is too weak',
      code: 'WEAK_PASSWORD',
    );
  }

  factory AuthException.sessionExpired() {
    return const AuthException(
      'Session has expired. Please login again.',
      code: 'SESSION_EXPIRED',
    );
  }

  factory AuthException.unauthorized() {
    return const AuthException(
      'You are not authorized to perform this action',
      code: 'UNAUTHORIZED',
    );
  }

  factory AuthException.forbidden() {
    return const AuthException(
      'Access denied. You do not have permission to access this resource.',
      code: 'FORBIDDEN',
    );
  }

  factory AuthException.accountDisabled() {
    return const AuthException(
      'Your account has been disabled. Please contact support.',
      code: 'ACCOUNT_DISABLED',
    );
  }

  factory AuthException.tooManyAttempts() {
    return const AuthException(
      'Too many failed attempts. Please try again later.',
      code: 'TOO_MANY_ATTEMPTS',
    );
  }
}

/// Validation exceptions
class ValidationException extends AppException {
  final Map<String, String>? fieldErrors;

  const ValidationException(
    super.message, {
    super.code,
    super.details,
    this.fieldErrors,
  });

  factory ValidationException.invalidEmail() {
    return const ValidationException(
      'Invalid email address',
      code: 'INVALID_EMAIL',
    );
  }

  factory ValidationException.invalidPassword() {
    return const ValidationException(
      'Invalid password',
      code: 'INVALID_PASSWORD',
    );
  }

  factory ValidationException.passwordMismatch() {
    return const ValidationException(
      'Passwords do not match',
      code: 'PASSWORD_MISMATCH',
    );
  }

  factory ValidationException.requiredField(String fieldName) {
    return ValidationException(
      '$fieldName is required',
      code: 'REQUIRED_FIELD',
    );
  }

  factory ValidationException.invalidFormat(String fieldName) {
    return ValidationException(
      'Invalid $fieldName format',
      code: 'INVALID_FORMAT',
    );
  }
}

/// Firebase exceptions
class FirebaseException extends AppException {
  const FirebaseException(
    super.message, {
    super.code,
    super.details,
  });

  factory FirebaseException.fromCode(String code, String? message) {
    switch (code) {
      case 'user-not-found':
        return const FirebaseException(
          'No user found for this email.',
          code: 'USER_NOT_FOUND',
        );
      case 'wrong-password':
        return const FirebaseException(
          'Wrong password provided.',
          code: 'WRONG_PASSWORD',
        );
      case 'email-already-in-use':
        return const FirebaseException(
          'The email address is already in use by another account.',
          code: 'EMAIL_ALREADY_IN_USE',
        );
      case 'weak-password':
        return const FirebaseException(
          'The password is too weak.',
          code: 'WEAK_PASSWORD',
        );
      case 'invalid-email':
        return const FirebaseException(
          'The email address is badly formatted.',
          code: 'INVALID_EMAIL',
        );
      case 'user-disabled':
        return const FirebaseException(
          'The user account has been disabled.',
          code: 'USER_DISABLED',
        );
      case 'too-many-requests':
        return const FirebaseException(
          'Too many requests. Try again later.',
          code: 'TOO_MANY_REQUESTS',
        );
      case 'operation-not-allowed':
        return const FirebaseException(
          'This operation is not allowed.',
          code: 'OPERATION_NOT_ALLOWED',
        );
      case 'permission-denied':
        return const FirebaseException(
          'You do not have permission to access this resource.',
          code: 'PERMISSION_DENIED',
        );
      case 'not-found':
        return const FirebaseException(
          'The requested resource was not found.',
          code: 'NOT_FOUND',
        );
      case 'already-exists':
        return const FirebaseException(
          'The resource already exists.',
          code: 'ALREADY_EXISTS',
        );
      case 'resource-exhausted':
        return const FirebaseException(
          'Resource quota exceeded.',
          code: 'RESOURCE_EXHAUSTED',
        );
      case 'cancelled':
        return const FirebaseException(
          'The operation was cancelled.',
          code: 'CANCELLED',
        );
      case 'data-loss':
        return const FirebaseException(
          'Unrecoverable data loss or corruption.',
          code: 'DATA_LOSS',
        );
      case 'unauthenticated':
        return const FirebaseException(
          'The request does not have valid authentication credentials.',
          code: 'UNAUTHENTICATED',
        );
      case 'unavailable':
        return const FirebaseException(
          'The service is currently unavailable.',
          code: 'UNAVAILABLE',
        );
      case 'deadline-exceeded':
        return const FirebaseException(
          'The deadline was exceeded before the operation could complete.',
          code: 'DEADLINE_EXCEEDED',
        );
      default:
        return FirebaseException(
          message ?? 'An unknown Firebase error occurred.',
          code: code,
        );
    }
  }
}

/// Storage exceptions
class StorageException extends AppException {
  const StorageException(
    super.message, {
    super.code,
    super.details,
  });

  factory StorageException.fileTooLarge(int maxSizeMB) {
    return StorageException(
      'File size exceeds the maximum allowed size of ${maxSizeMB}MB.',
      code: 'FILE_TOO_LARGE',
      details: {'maxSizeMB': maxSizeMB},
    );
  }

  factory StorageException.invalidFileType(List<String> allowedTypes) {
    return StorageException(
      'Invalid file type. Allowed types: ${allowedTypes.join(', ')}',
      code: 'INVALID_FILE_TYPE',
      details: {'allowedTypes': allowedTypes},
    );
  }

  factory StorageException.uploadFailed() {
    return const StorageException(
      'Failed to upload file. Please try again.',
      code: 'UPLOAD_FAILED',
    );
  }

  factory StorageException.downloadFailed() {
    return const StorageException(
      'Failed to download file. Please try again.',
      code: 'DOWNLOAD_FAILED',
    );
  }

  factory StorageException.quotaExceeded() {
    return const StorageException(
      'Storage quota exceeded. Please free up some space.',
      code: 'QUOTA_EXCEEDED',
    );
  }
}

/// Cache exceptions
class CacheException extends AppException {
  const CacheException(
    super.message, {
    super.code,
    super.details,
  });

  factory CacheException.notFound(String key) {
    return CacheException(
      'Cache item not found: $key',
      code: 'CACHE_NOT_FOUND',
      details: {'key': key},
    );
  }

  factory CacheException.writeError(String key) {
    return CacheException(
      'Failed to write to cache: $key',
      code: 'CACHE_WRITE_ERROR',
      details: {'key': key},
    );
  }

  factory CacheException.readError(String key) {
    return CacheException(
      'Failed to read from cache: $key',
      code: 'CACHE_READ_ERROR',
      details: {'key': key},
    );
  }
}

/// Permission exceptions
class PermissionException extends AppException {
  const PermissionException(
    super.message, {
    super.code,
    super.details,
  });

  factory PermissionException.cameraDenied() {
    return const PermissionException(
      'Camera permission is required to take photos.',
      code: 'CAMERA_DENIED',
    );
  }

  factory PermissionException.storageDenied() {
    return const PermissionException(
      'Storage permission is required to save files.',
      code: 'STORAGE_DENIED',
    );
  }

  factory PermissionException.photosDenied() {
    return const PermissionException(
      'Photos permission is required to access your photo library.',
      code: 'PHOTOS_DENIED',
    );
  }

  factory PermissionException.microphoneDenied() {
    return const PermissionException(
      'Microphone permission is required for audio features.',
      code: 'MICROPHONE_DENIED',
    );
  }
}

/// Business logic exceptions
class BusinessException extends AppException {
  const BusinessException(
    super.message, {
    super.code,
    super.details,
  });

  factory BusinessException.insufficientStock(String productName, int available) {
    return BusinessException(
      'Insufficient stock for $productName. Available: $available',
      code: 'INSUFFICIENT_STOCK',
      details: {'productName': productName, 'available': available},
    );
  }

  factory BusinessException.productNotFound(String productName) {
    return BusinessException(
      'Product not found: $productName',
      code: 'PRODUCT_NOT_FOUND',
      details: {'productName': productName},
    );
  }

  factory BusinessException.orderNotFound(String orderId) {
    return BusinessException(
      'Order not found: $orderId',
      code: 'ORDER_NOT_FOUND',
      details: {'orderId': orderId},
    );
  }

  factory BusinessException.invalidOrderStatus(String currentStatus, String requiredStatus) {
    return BusinessException(
      'Cannot update order. Current status: $currentStatus, Required: $requiredStatus',
      code: 'INVALID_ORDER_STATUS',
      details: {
        'currentStatus': currentStatus,
        'requiredStatus': requiredStatus,
      },
    );
  }

  factory BusinessException.duplicateEntry(String field, String value) {
    return BusinessException(
      'A record with this $field already exists: $value',
      code: 'DUPLICATE_ENTRY',
      details: {'field': field, 'value': value},
    );
  }
}