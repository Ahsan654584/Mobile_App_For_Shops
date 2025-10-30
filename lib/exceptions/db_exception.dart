/// Exception for database-related errors
class DatabaseException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  DatabaseException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'DatabaseException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception for SQLite operations
class SQLiteException extends DatabaseException {
  SQLiteException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(
    message: message,
    code: code ?? 'sqlite_error',
    originalError: originalError,
  );
}

/// Exception for Firestore operations
class FirestoreException extends DatabaseException {
  FirestoreException({
    required String message,
    String? code,
    dynamic originalError,
  }) : super(
    message: message,
    code: code ?? 'firestore_error',
    originalError: originalError,
  );
}

/// Exception when data is not found
class DataNotFoundException extends DatabaseException {
  DataNotFoundException({String? message})
      : super(
          message: message ?? 'Data not found',
          code: 'not_found',
        );
}

/// Exception for database initialization failure
class DatabaseInitializationException extends DatabaseException {
  DatabaseInitializationException({String? message})
      : super(
          message: message ?? 'Failed to initialize database',
          code: 'initialization_failed',
        );
}

/// Exception for data write conflicts
class DataConflictException extends DatabaseException {
  DataConflictException({String? message})
      : super(
          message: message ?? 'Data conflict during write',
          code: 'conflict',
        );
}
