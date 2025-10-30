/// Exception for synchronization-related errors
class SyncException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  SyncException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'SyncException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception for sync conflicts
class SyncConflictException extends SyncException {
  SyncConflictException({String? message})
      : super(
          message: message ?? 'Sync conflict detected',
          code: 'sync_conflict',
        );
}

/// Exception for offline sync queue failure
class SyncQueueException extends SyncException {
  SyncQueueException({String? message})
      : super(
          message: message ?? 'Failed to queue sync operation',
          code: 'queue_failed',
        );
}

/// Exception for network connectivity issues during sync
class SyncNetworkException extends SyncException {
  SyncNetworkException({String? message})
      : super(
          message: message ?? 'Network error during sync',
          code: 'network_error',
        );
}

/// Exception for sync timeout
class SyncTimeoutException extends SyncException {
  SyncTimeoutException({String? message})
      : super(
          message: message ?? 'Sync operation timed out',
          code: 'timeout',
        );
}
