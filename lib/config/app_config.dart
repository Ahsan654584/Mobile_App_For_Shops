/// Global application configuration
class AppConfig {
  static const String appName = 'Mobile App For Shops';
  static const String appVersion = '1.0.0';

  // API & Network
  static const Duration apiTimeout = Duration(seconds: 30);
  static const Duration syncInterval = Duration(seconds: 300);

  // Database
  static const String databaseName = 'shops.db';
  static const int databaseVersion = 1;

  // Firestore Collections
  static const String firestoreUsersCollection = 'users';
  static const String firestoreShopsCollection = 'shops';
  static const String firestoreItemsCollection = 'items';
  static const String firestoreOrdersCollection = 'orders';

  // SQLite Tables
  static const String sqliteUsersTable = 'users_local';
  static const String sqliteShopsTable = 'shops_local';
  static const String sqliteItemsTable = 'items_local';
  static const String syncQueueTable = 'sync_queue';
  static const String syncMetadataTable = 'sync_metadata';

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;

  // Pagination
  static const int pageSize = 20;

  // Retry Policy
  static const int maxRetryAttempts = 3;
  static const Duration retryDelay = Duration(seconds: 2);

  // Platforms
  static const String iosMinimumVersion = '11.0';
  static const int androidMinimumApi = 21;
}
