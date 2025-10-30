import 'package:flutter/material.dart';
import '../services/connectivity_service.dart';
import '../utils/logger.dart';

/// Provider for managing network connectivity state
class ConnectivityProvider extends ChangeNotifier {
  final ConnectivityService _connectivityService;

  bool _isOnline = true;

  ConnectivityProvider({required ConnectivityService connectivityService})
      : _connectivityService = connectivityService {
    _initialize();
  }

  /// Initialize provider
  void _initialize() {
    AppLogger.info('Initializing ConnectivityProvider');
    _checkConnectivity();
    _listenToConnectivityChanges();
  }

  /// Check current connectivity status
  Future<void> _checkConnectivity() async {
    try {
      _isOnline = await _connectivityService.isOnline();
      notifyListeners();
    } catch (e) {
      AppLogger.error('Error checking connectivity', e);
    }
  }

  /// Listen to connectivity changes
  void _listenToConnectivityChanges() {
    _connectivityService.connectionStatusStream.listen((isOnline) {
      if (_isOnline != isOnline) {
        _isOnline = isOnline;
        AppLogger.info('Connectivity status changed: $_isOnline');
        notifyListeners();
      }
    });
  }

  /// Get online status
  bool get isOnline => _isOnline;

  /// Get offline status
  bool get isOffline => !_isOnline;

  /// Get connection status message
  String get statusMessage => _isOnline
      ? 'Connected to the internet'
      : 'No internet connection';
}
