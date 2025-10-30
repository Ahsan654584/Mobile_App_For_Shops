import 'package:connectivity_plus/connectivity_plus.dart';
import '../utils/logger.dart';

/// Service to monitor network connectivity
class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  late final Connectivity _connectivity;
  late final Stream<List<ConnectivityResult>> _connectionStatusStream;

  factory ConnectivityService() {
    return _instance;
  }

  ConnectivityService._internal();

  /// Initialize connectivity service
  void initialize() {
    _connectivity = Connectivity();
    _connectionStatusStream = _connectivity.onConnectivityChanged;
    AppLogger.info('ConnectivityService initialized');
  }

  /// Check current connectivity status
  Future<bool> isOnline() async {
    try {
      final result = await _connectivity.checkConnectivity();
      final isOnline = result != ConnectivityResult.none;
      AppLogger.debug('Connectivity status: $isOnline (${result.name})');
      return isOnline;
    } catch (e) {
      AppLogger.error('Error checking connectivity', e);
      return false;
    }
  }

  /// Get connectivity status stream
  Stream<bool> get connectionStatusStream {
    return _connectionStatusStream.map((results) {
      final isOnline = !results.contains(ConnectivityResult.none);
      AppLogger.debug('Connectivity changed: $isOnline');
      return isOnline;
    }).distinct();
  }

  /// Get detailed connectivity results
  Future<List<ConnectivityResult>> getConnectivityResult() async {
    try {
      return await _connectivity.checkConnectivity();
    } catch (e) {
      AppLogger.error('Error getting connectivity result', e);
      return [ConnectivityResult.none];
    }
  }

  /// Check if WiFi is connected
  Future<bool> isWifiConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result == ConnectivityResult.wifi;
    } catch (e) {
      AppLogger.error('Error checking WiFi connection', e);
      return false;
    }
  }

  /// Check if mobile data is connected
  Future<bool> isMobileConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      return result == ConnectivityResult.mobile;
    } catch (e) {
      AppLogger.error('Error checking mobile connection', e);
      return false;
    }
  }
}
