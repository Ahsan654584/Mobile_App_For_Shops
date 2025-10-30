import 'package:flutter/material.dart';
import '../models/user.dart' as app_user;
import '../services/auth_service.dart';
import '../exceptions/auth_exception.dart';
import '../utils/logger.dart';

/// Provider for managing authentication state
class AuthProvider extends ChangeNotifier {
  final AuthService _authService;

  app_user.User? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({required AuthService authService}) : _authService = authService {
    _initialize();
  }

  /// Initialize provider
  void _initialize() {
    AppLogger.info('Initializing AuthProvider');
    _checkCurrentUser();
  }

  /// Check if user is already logged in
  Future<void> _checkCurrentUser() async {
    try {
      _currentUser = await _authService.getCurrentUser();
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error checking current user', e);
    }
  }

  /// Sign up with email and password
  Future<void> signUp({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser = await _authService.signUp(
        email: email,
        password: password,
      );

      AppLogger.info('Sign up successful for: $email');
      _errorMessage = null;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      AppLogger.warning('Sign up error: ${e.message}');
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      AppLogger.error('Unexpected error during sign up', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Log in with email and password
  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _currentUser = await _authService.login(
        email: email,
        password: password,
      );

      AppLogger.info('Login successful for: $email');
      _errorMessage = null;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      AppLogger.warning('Login error: ${e.message}');
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      AppLogger.error('Unexpected error during login', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Log out
  Future<void> logout() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.logout();
      _currentUser = null;

      AppLogger.info('Logout successful');
      _errorMessage = null;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      AppLogger.warning('Logout error: ${e.message}');
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      AppLogger.error('Unexpected error during logout', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Request password reset
  Future<void> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _authService.resetPassword(email);
      AppLogger.info('Password reset email sent to: $email');
      _errorMessage = null;
    } on AuthException catch (e) {
      _errorMessage = e.message;
      AppLogger.warning('Password reset error: ${e.message}');
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      AppLogger.error('Unexpected error during password reset', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Getters
  app_user.User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  String get userEmail => _currentUser?.email ?? '';
  String get userName => _currentUser?.displayName ?? 'User';
}
