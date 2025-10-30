import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as app_user;
import '../exceptions/auth_exception.dart';
import '../utils/logger.dart';

/// Authentication service interface
/// Placeholder for Firebase Authentication integration
class AuthService {
  static final AuthService _instance = AuthService._internal();
  late final FirebaseAuth _firebaseAuth;

  factory AuthService() {
    return _instance;
  }

  AuthService._internal();

  /// Initialize Firebase Auth
  void initialize() {
    _firebaseAuth = FirebaseAuth.instance;
    AppLogger.info('AuthService initialized');
  }

  /// Sign up with email and password
  /// Returns the created user
  Future<app_user.User> signUp({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Signing up user: $email');

      // Validate inputs
      _validateEmail(email);
      _validatePassword(password);

      // Create user in Firebase
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw AuthException(
          message: 'Failed to create user',
          code: 'user_creation_failed',
        );
      }

      // Create app user model
      final appUser = app_user.User(
        id: firebaseUser.uid,
        email: email,
        displayName: firebaseUser.displayName ?? email.split('@')[0],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: firebaseUser.emailVerified,
      );

      AppLogger.info('User signed up successfully: $email');
      return appUser;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error during signup: ${e.code}', e);
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      AppLogger.error('Unexpected error during signup', e);
      rethrow;
    }
  }

  /// Log in with email and password
  /// Returns the authenticated user
  Future<app_user.User> login({
    required String email,
    required String password,
  }) async {
    try {
      AppLogger.info('Logging in user: $email');

      // Validate inputs
      _validateEmail(email);
      _validatePassword(password);

      // Authenticate with Firebase
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final firebaseUser = userCredential.user;
      if (firebaseUser == null) {
        throw AuthException(
          message: 'Failed to authenticate user',
          code: 'authentication_failed',
        );
      }

      // Create app user model
      final appUser = app_user.User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? email,
        displayName: firebaseUser.displayName ?? email.split('@')[0],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: firebaseUser.emailVerified,
      );

      AppLogger.info('User logged in successfully: $email');
      return appUser;
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error during login: ${e.code}', e);
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      AppLogger.error('Unexpected error during login', e);
      rethrow;
    }
  }

  /// Log out the current user
  Future<void> logout() async {
    try {
      AppLogger.info('Logging out user');
      await _firebaseAuth.signOut();
      AppLogger.info('User logged out successfully');
    } catch (e) {
      AppLogger.error('Error during logout', e);
      throw AuthException(
        message: 'Failed to logout',
        code: 'logout_failed',
        originalError: e,
      );
    }
  }

  /// Send password reset email
  Future<void> resetPassword(String email) async {
    try {
      AppLogger.info('Sending password reset email to: $email');
      _validateEmail(email);

      await _firebaseAuth.sendPasswordResetEmail(email: email);
      AppLogger.info('Password reset email sent to: $email');
    } on FirebaseAuthException catch (e) {
      AppLogger.error('Firebase auth error during password reset: ${e.code}', e);
      throw _handleFirebaseAuthException(e);
    } catch (e) {
      AppLogger.error('Unexpected error during password reset', e);
      rethrow;
    }
  }

  /// Get current authenticated user
  Future<app_user.User?> getCurrentUser() async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;

      if (firebaseUser == null) {
        return null;
      }

      return app_user.User(
        id: firebaseUser.uid,
        email: firebaseUser.email ?? '',
        displayName: firebaseUser.displayName ?? 'User',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        isEmailVerified: firebaseUser.emailVerified,
      );
    } catch (e) {
      AppLogger.error('Error getting current user', e);
      return null;
    }
  }

  /// Check if user is authenticated
  bool get isAuthenticated => _firebaseAuth.currentUser != null;

  /// Get current Firebase user
  User? get currentUser => _firebaseAuth.currentUser;

  /// Get auth state changes stream
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  /// Validate email format
  void _validateEmail(String email) {
    if (email.isEmpty) {
      throw AuthException(
        message: 'Email is required',
        code: 'invalid_email',
      );
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      throw AuthException(
        message: 'Invalid email format',
        code: 'invalid_email',
      );
    }
  }

  /// Validate password strength
  void _validatePassword(String password) {
    if (password.isEmpty) {
      throw AuthException(
        message: 'Password is required',
        code: 'invalid_password',
      );
    }

    if (password.length < 8) {
      throw WeakPasswordException(
        message: 'Password must be at least 8 characters',
      );
    }
  }

  /// Handle Firebase authentication exceptions
  AuthException _handleFirebaseAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return WeakPasswordException(message: e.message);
      case 'email-already-in-use':
        return UserAlreadyExistsException(message: e.message);
      case 'user-not-found':
        return UserNotFoundException(message: e.message);
      case 'wrong-password':
        return InvalidCredentialsException(message: e.message);
      case 'invalid-email':
        return AuthException(
          message: 'Invalid email address',
          code: e.code,
          originalError: e,
        );
      case 'too-many-requests':
        return AuthException(
          message: 'Too many login attempts. Please try again later.',
          code: e.code,
          originalError: e,
        );
      default:
        return AuthException(
          message: e.message ?? 'Authentication error',
          code: e.code,
          originalError: e,
        );
    }
  }
}
