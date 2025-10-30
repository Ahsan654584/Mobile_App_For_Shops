import '../config/app_config.dart';
import '../exceptions/sync_exception.dart';
import '../utils/logger.dart';
import 'connectivity_service.dart';
import 'sqlite_service.dart';
import 'firestore_service.dart';

/// Service to orchestrate offline/online synchronization
/// Placeholder for sync logic
class SyncService {
  static final SyncService _instance = SyncService._internal();
  late final ConnectivityService _connectivityService;
  late final SQLiteService _sqliteService;
  late final FirestoreService _firestoreService;

  bool _isSyncing = false;
  DateTime? _lastSyncTime;

  factory SyncService() {
    return _instance;
  }

  SyncService._internal();

  /// Initialize sync service with dependencies
  void initialize({
    required ConnectivityService connectivityService,
    required SQLiteService sqliteService,
    required FirestoreService firestoreService,
  }) {
    _connectivityService = connectivityService;
    _sqliteService = sqliteService;
    _firestoreService = firestoreService;
    AppLogger.info('SyncService initialized');
  }

  /// Start listening for connectivity changes and trigger sync
  void startSyncListener() {
    try {
      AppLogger.info('Starting sync listener');

      _connectivityService.connectionStatusStream.listen((isOnline) {
        if (isOnline) {
          AppLogger.info('Device online - triggering sync');
          synchronize();
        } else {
          AppLogger.info('Device offline - sync paused');
        }
      });
    } catch (e) {
      AppLogger.error('Error starting sync listener', e);
    }
  }

  /// Perform synchronization
  /// Syncs pending operations from SQLite queue to Firestore
  Future<void> synchronize() async {
    if (_isSyncing) {
      AppLogger.warning('Sync already in progress');
      return;
    }

    try {
      _isSyncing = true;
      AppLogger.info('Starting synchronization');

      final isOnline = await _connectivityService.isOnline();
      if (!isOnline) {
        throw SyncNetworkException(
          message: 'Device is offline',
        );
      }

      // TODO: Implement actual sync logic
      // 1. Fetch pending operations from sync queue
      // 2. Push to Firestore
      // 3. Pull updates from Firestore
      // 4. Update local SQLite
      // 5. Update sync metadata

      _lastSyncTime = DateTime.now();
      AppLogger.info('Synchronization completed');
    } catch (e) {
      AppLogger.error('Error during synchronization', e);
      rethrow;
    } finally {
      _isSyncing = false;
    }
  }

  /// Add operation to sync queue
  Future<void> queueOperation({
    required String operation,
    required String collectionName,
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.debug('Queueing operation: $operation on $collectionName/$documentId');

      final queueItem = {
        'id': '${DateTime.now().millisecondsSinceEpoch}_$documentId',
        'operation': operation,
        'collectionName': collectionName,
        'documentId': documentId,
        'data': data.toString(),
        'status': 'pending',
        'createdAt': DateTime.now().toIso8601String(),
        'retryCount': 0,
      };

      await _sqliteService.insert(
        table: AppConfig.syncQueueTable,
        data: queueItem,
      );

      AppLogger.info('Operation queued successfully');
    } catch (e) {
      AppLogger.error('Error queueing operation', e);
      throw SyncQueueException(
        message: 'Failed to queue sync operation',
      );
    }
  }

  /// Get pending sync operations
  Future<List<Map<String, dynamic>>> getPendingOperations() async {
    try {
      return await _sqliteService.query(
        table: AppConfig.syncQueueTable,
        where: 'status = ?',
        whereArgs: ['pending'],
        orderBy: 'createdAt ASC',
      );
    } catch (e) {
      AppLogger.error('Error fetching pending operations', e);
      throw SyncQueueException(
        message: 'Failed to fetch pending operations',
      );
    }
  }

  /// Clear completed sync operations
  Future<void> clearCompletedOperations() async {
    try {
      await _sqliteService.delete(
        table: AppConfig.syncQueueTable,
        where: 'status = ?',
        whereArgs: ['completed'],
      );
      AppLogger.info('Completed sync operations cleared');
    } catch (e) {
      AppLogger.error('Error clearing completed operations', e);
    }
  }

  /// Update last sync time for a collection
  Future<void> updateLastSyncTime(String collectionName) async {
    try {
      final now = DateTime.now().toIso8601String();

      final existing = await _sqliteService.query(
        table: AppConfig.syncMetadataTable,
        where: 'collectionName = ?',
        whereArgs: [collectionName],
      );

      if (existing.isEmpty) {
        await _sqliteService.insert(
          table: AppConfig.syncMetadataTable,
          data: {
            'id': collectionName,
            'collectionName': collectionName,
            'lastSyncTime': now,
            'status': 'synced',
          },
        );
      } else {
        await _sqliteService.update(
          table: AppConfig.syncMetadataTable,
          data: {
            'lastSyncTime': now,
            'status': 'synced',
          },
          where: 'collectionName = ?',
          whereArgs: [collectionName],
        );
      }

      AppLogger.info('Updated last sync time for: $collectionName');
    } catch (e) {
      AppLogger.error('Error updating last sync time', e);
    }
  }

  /// Get last sync time for a collection
  Future<DateTime?> getLastSyncTime(String collectionName) async {
    try {
      final result = await _sqliteService.query(
        table: AppConfig.syncMetadataTable,
        where: 'collectionName = ?',
        whereArgs: [collectionName],
        limit: 1,
      );

      if (result.isEmpty) {
        return null;
      }

      final lastSyncTimeStr = result.first['lastSyncTime'] as String?;
      return lastSyncTimeStr != null ? DateTime.parse(lastSyncTimeStr) : null;
    } catch (e) {
      AppLogger.error('Error getting last sync time', e);
      return null;
    }
  }

  /// Check if currently syncing
  bool get isSyncing => _isSyncing;

  /// Get last sync time
  DateTime? get lastSyncTime => _lastSyncTime;

  /// Get count of pending operations
  Future<int> getPendingOperationCount() async {
    try {
      final results = await _sqliteService.query(
        table: AppConfig.syncQueueTable,
        where: 'status = ?',
        whereArgs: ['pending'],
      );
      return results.length;
    } catch (e) {
      AppLogger.error('Error getting pending operation count', e);
      return 0;
    }
  }
}
