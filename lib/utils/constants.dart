import 'package:flutter/material.dart';

/// Application-wide constants
class AppConstants {
  // Color Scheme
  static const Color primaryColor = Color(0xFF2563EB);
  static const Color primaryDarkColor = Color(0xFF1E40AF);
  static const Color primaryLightColor = Color(0xFFDECBF5);
  static const Color accentColor = Color(0xFF10B981);
  static const Color accentDarkColor = Color(0xFF047857);
  static const Color backgroundColor = Color(0xFFF9FAFB);
  static const Color surfaceColor = Color(0xFFFFFFFF);
  static const Color errorColor = Color(0xFFEF4444);
  static const Color warningColor = Color(0xFFF59E0B);
  static const Color successColor = Color(0xFF10B981);
  static const Color infoColor = Color(0xFF3B82F6);

  // Text Colors
  static const Color textPrimaryColor = Color(0xFF111827);
  static const Color textSecondaryColor = Color(0xFF6B7280);
  static const Color textTertiaryColor = Color(0xFF9CA3AF);

  // Firestore Collections
  static const String usersCollection = 'users';
  static const String shopsCollection = 'shops';
  static const String itemsCollection = 'items';
  static const String ordersCollection = 'orders';

  // SQLite Tables
  static const String usersLocalTable = 'users_local';
  static const String shopsLocalTable = 'shops_local';
  static const String itemsLocalTable = 'items_local';
  static const String syncQueueTable = 'sync_queue';
  static const String syncMetadataTable = 'sync_metadata';

  // Error Messages
  static const String errorGeneric = 'An error occurred. Please try again.';
  static const String errorNetwork = 'Network error. Please check your connection.';
  static const String errorTimeout = 'Request timed out. Please try again.';
  static const String errorInvalidEmail = 'Please enter a valid email address.';
  static const String errorInvalidPassword = 'Password must be at least 8 characters.';
  static const String errorPasswordMismatch = 'Passwords do not match.';
  static const String errorEmptyField = 'This field cannot be empty.';
  static const String errorUserNotFound = 'User not found.';
  static const String errorUserExists = 'User already exists.';
  static const String errorUnauthorized = 'Unauthorized. Please log in again.';
  static const String errorServerError = 'Server error. Please try again later.';

  // Success Messages
  static const String successSignup = 'Account created successfully. Please log in.';
  static const String successLogin = 'Login successful.';
  static const String successLogout = 'Logged out successfully.';
  static const String successPasswordReset = 'Password reset email sent. Check your inbox.';
  static const String successDataSynced = 'Data synchronized successfully.';

  // Common Strings
  static const String appName = 'Mobile App For Shops';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String ok = 'OK';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String edit = 'Edit';
  static const String back = 'Back';
  static const String logout = 'Logout';
  static const String settings = 'Settings';
  static const String profile = 'Profile';
}

/// Text Styles
class AppTextStyles {
  // Headings
  static const TextStyle heading1 = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: AppConstants.textPrimaryColor,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppConstants.textPrimaryColor,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppConstants.textPrimaryColor,
  );

  // Body
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppConstants.textPrimaryColor,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppConstants.textPrimaryColor,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppConstants.textSecondaryColor,
  );

  // Caption
  static const TextStyle caption = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.normal,
    color: AppConstants.textTertiaryColor,
  );

  // Button
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );
}

/// Spacing Constants
class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

/// Border Radius Constants
class AppBorderRadius {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 20.0;
  static const double full = 9999.0;
}
