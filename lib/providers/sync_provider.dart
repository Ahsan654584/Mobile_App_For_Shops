import 'package:flutter/material.dart';
import '../services/sync_service.dart';
import '../services/connectivity_service.dart';
import '../utils/logger.dart';

/// Provider for managing sync status and operations
/// Placeholder for sync state management
class SyncProvider extends ChangeNotifier {
  final SyncService _syncService;
  final ConnectivityService _connectivityService;

  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  int _pendingOperationCount = 0;

  SyncProvider({
    required SyncService syncService,
    required ConnectivityService connectivityService,
  })  : _syncService = syncService,
        _connectivityService = connectivityService {
    _initialize();
  }

  void _initialize() {
    AppLogger.info('Initializing SyncProvider');
    _listenToSyncChanges();
  }

  /// Listen to sync changes
  void _listenToSyncChanges() {
    _connectivityService.connectionStatusStream.listen((isOnline) {
      if (isOnline) {
        _updateSyncStatus();
      }
    });
  }

  /// Update sync status
  Future<void> _updateSyncStatus() async {
    _isSyncing = _syncService.isSyncing;
    _lastSyncTime = _syncService.lastSyncTime;
    _pendingOperationCount = await _syncService.getPendingOperationCount();
    notifyListeners();
  }

  /// Manually trigger sync
  Future<void> triggerSync() async {
    try {
      _isSyncing = true;
      notifyListeners();

      await _syncService.synchronize();
      await _updateSyncStatus();
    } catch (e) {
      AppLogger.error('Error triggering sync', e);
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  // Getters
  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;
  int get pendingOperationCount => _pendingOperationCount;
  String get lastSyncMessage => _lastSyncTime != null
      ? 'Last synced: ${_lastSyncTime!.toLocal()}'
      : 'Never synced';
}
