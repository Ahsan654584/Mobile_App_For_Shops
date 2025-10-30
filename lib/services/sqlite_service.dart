import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../config/app_config.dart';
import '../exceptions/db_exception.dart';
import '../utils/logger.dart';

/// SQLite database service for offline storage
/// Placeholder for local database operations
class SQLiteService {
  static final SQLiteService _instance = SQLiteService._internal();
  late Database _db;
  bool _isInitialized = false;

  factory SQLiteService() {
    return _instance;
  }

  SQLiteService._internal();

  /// Initialize SQLite database
  Future<void> initialize() async {
    try {
      if (_isInitialized) {
        return;
      }

      final directory = await getApplicationDocumentsDirectory();
      final path = '${directory.path}/${AppConfig.databaseName}';

      AppLogger.info('Initializing SQLite at: $path');

      _db = await openDatabase(
        path,
        version: AppConfig.databaseVersion,
        onCreate: _onCreate,
        onUpgrade: _onUpgrade,
      );

      _isInitialized = true;
      AppLogger.info('SQLite initialized successfully');
    } catch (e) {
      AppLogger.error('SQLite initialization error', e);
      throw DatabaseInitializationException(
        message: 'Failed to initialize SQLite database',
      );
    }
  }

  /// Create database tables
  Future<void> _onCreate(Database db, int version) async {
    try {
      AppLogger.info('Creating database tables (version: $version)');

      // Users local table
      await db.execute('''
        CREATE TABLE ${AppConfig.sqliteUsersTable} (
          id TEXT PRIMARY KEY,
          email TEXT NOT NULL,
          displayName TEXT NOT NULL,
          profilePictureUrl TEXT,
          isEmailVerified INTEGER DEFAULT 0,
          phoneNumber TEXT,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');

      // Shops local table
      await db.execute('''
        CREATE TABLE ${AppConfig.sqliteShopsTable} (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          ownerId TEXT NOT NULL,
          address TEXT NOT NULL,
          city TEXT,
          state TEXT,
          postalCode TEXT,
          phone TEXT,
          email TEXT,
          website TEXT,
          isActive INTEGER DEFAULT 1,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');

      // Items local table
      await db.execute('''
        CREATE TABLE ${AppConfig.sqliteItemsTable} (
          id TEXT PRIMARY KEY,
          name TEXT NOT NULL,
          description TEXT,
          price REAL,
          quantity INTEGER DEFAULT 0,
          shopId TEXT NOT NULL,
          createdAt TEXT NOT NULL,
          updatedAt TEXT NOT NULL
        )
      ''');

      // Sync queue table
      await db.execute('''
        CREATE TABLE ${AppConfig.syncQueueTable} (
          id TEXT PRIMARY KEY,
          operation TEXT NOT NULL,
          collectionName TEXT NOT NULL,
          documentId TEXT NOT NULL,
          data TEXT NOT NULL,
          status TEXT DEFAULT 'pending',
          createdAt TEXT NOT NULL,
          retryCount INTEGER DEFAULT 0
        )
      ''');

      // Sync metadata table
      await db.execute('''
        CREATE TABLE ${AppConfig.syncMetadataTable} (
          id TEXT PRIMARY KEY,
          collectionName TEXT NOT NULL UNIQUE,
          lastSyncTime TEXT,
          status TEXT DEFAULT 'synced'
        )
      ''');

      AppLogger.info('Database tables created successfully');
    } catch (e) {
      AppLogger.error('Error creating database tables', e);
      throw DatabaseInitializationException(
        message: 'Failed to create database tables',
      );
    }
  }

  /// Handle database upgrades
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    AppLogger.info('Upgrading database from v$oldVersion to v$newVersion');
    // Future migrations will be added here
  }

  /// Insert a record
  Future<int> insert({
    required String table,
    required Map<String, dynamic> data,
  }) async {
    try {
      if (!_isInitialized) await initialize();
      return await _db.insert(table, data);
    } catch (e) {
      AppLogger.error('Error inserting into $table', e);
      throw SQLiteException(
        message: 'Failed to insert record',
        originalError: e,
      );
    }
  }

  /// Query records
  Future<List<Map<String, dynamic>>> query({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      return await _db.query(
        table,
        where: where,
        whereArgs: whereArgs,
        orderBy: orderBy,
        limit: limit,
      );
    } catch (e) {
      AppLogger.error('Error querying $table', e);
      throw SQLiteException(
        message: 'Failed to query records',
        originalError: e,
      );
    }
  }

  /// Get a single record by ID
  Future<Map<String, dynamic>?> getById({
    required String table,
    required String id,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      final results = await _db.query(
        table,
        where: 'id = ?',
        whereArgs: [id],
        limit: 1,
      );

      return results.isEmpty ? null : results.first;
    } catch (e) {
      AppLogger.error('Error getting record from $table', e);
      throw SQLiteException(
        message: 'Failed to get record',
        originalError: e,
      );
    }
  }

  /// Update a record
  Future<int> update({
    required String table,
    required Map<String, dynamic> data,
    required String where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      return await _db.update(
        table,
        data,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      AppLogger.error('Error updating $table', e);
      throw SQLiteException(
        message: 'Failed to update record',
        originalError: e,
      );
    }
  }

  /// Delete records
  Future<int> delete({
    required String table,
    String? where,
    List<dynamic>? whereArgs,
  }) async {
    try {
      if (!_isInitialized) await initialize();

      return await _db.delete(
        table,
        where: where,
        whereArgs: whereArgs,
      );
    } catch (e) {
      AppLogger.error('Error deleting from $table', e);
      throw SQLiteException(
        message: 'Failed to delete records',
        originalError: e,
      );
    }
  }

  /// Batch transaction
  Future<void> transaction(Future<void> Function(Transaction txn) action) async {
    try {
      if (!_isInitialized) await initialize();
      await _db.transaction((_) => action(_));
    } catch (e) {
      AppLogger.error('Error in database transaction', e);
      throw SQLiteException(
        message: 'Transaction failed',
        originalError: e,
      );
    }
  }

  /// Close database
  Future<void> close() async {
    try {
      if (_isInitialized) {
        await _db.close();
        _isInitialized = false;
        AppLogger.info('SQLite database closed');
      }
    } catch (e) {
      AppLogger.error('Error closing database', e);
    }
  }

  /// Check if initialized
  bool get isInitialized => _isInitialized;

  /// Get database instance
  Database get database {
    if (!_isInitialized) {
      throw DatabaseInitializationException(
        message: 'Database not initialized',
      );
    }
    return _db;
  }
}
