/// Exception for authentication-related errors
class AuthException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;

  AuthException({
    required this.message,
    this.code,
    this.originalError,
  });

  @override
  String toString() => 'AuthException: $message${code != null ? ' (Code: $code)' : ''}';
}

/// Exception for invalid credentials
class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException({String? message})
      : super(
          message: message ?? 'Invalid email or password',
          code: 'invalid_credentials',
        );
}

/// Exception for user not found
class UserNotFoundException extends AuthException {
  UserNotFoundException({String? message})
      : super(
          message: message ?? 'User not found',
          code: 'user_not_found',
        );
}

/// Exception for user already exists
class UserAlreadyExistsException extends AuthException {
  UserAlreadyExistsException({String? message})
      : super(
          message: message ?? 'User already exists',
          code: 'user_already_exists',
        );
}

/// Exception for weak password
class WeakPasswordException extends AuthException {
  WeakPasswordException({String? message})
      : super(
          message: message ?? 'Password is too weak',
          code: 'weak_password',
        );
}

/// Exception for session expired
class SessionExpiredException extends AuthException {
  SessionExpiredException({String? message})
      : super(
          message: message ?? 'Session expired. Please login again',
          code: 'session_expired',
        );
}
