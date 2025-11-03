import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  /// Login user with email and password
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    required bool rememberMe,
  });

  /// Register new user
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  });

  /// Logout current user
  Future<Either<Failure, void>> logout();

  /// Check if user is authenticated
  Future<Either<Failure, User>> checkAuthStatus();

  /// Send password reset email
  Future<Either<Failure, void>> sendPasswordResetEmail(String email);

  /// Reset password with code
  Future<Either<Failure, void>> resetPassword({
    required String code,
    required String newPassword,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Update user profile
  Future<Either<Failure, User>> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? photoURL,
  });

  /// Refresh authentication token
  Future<Either<Failure, String>> refreshToken();

  /// Delete user account
  Future<Either<Failure, void>> deleteAccount();

  /// Get current user ID
  String? getCurrentUserId();

  /// Stream of authentication state changes
  Stream<bool> get authStateChanges;

  /// Check if user has specific permission
  bool hasPermission(String permission);

  /// Get user role
  String? getUserRole();
}