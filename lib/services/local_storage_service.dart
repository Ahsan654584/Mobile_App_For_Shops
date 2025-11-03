import 'dart:convert';
import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/error/exceptions.dart';
import '../core/utils/constants.dart';

@singleton
class LocalStorageService {
  late SharedPreferences _prefs;
  late FlutterSecureStorage _secureStorage;
  late Directory _appDocumentsDir;
  late Directory _appTempDir;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
    _appDocumentsDir = await getApplicationDocumentsDirectory();
    _appTempDir = await getTemporaryDirectory();
  }

  // Shared Preferences methods
  Future<void> setString(String key, String value) async {
    try {
      await _prefs.setString(key, value);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (e) {
      throw CacheException.readError(key);
    }
  }

  Future<void> setStringList(String key, List<String> value) async {
    try {
      await _prefs.setStringList(key, value);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  List<String>? getStringList(String key) {
    try {
      return _prefs.getStringList(key);
    } catch (e) {
      throw CacheException.readError(key);
    }
  }

  Future<void> setInt(String key, int value) async {
    try {
      await _prefs.setInt(key, value);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (e) {
      throw CacheException.readError(key);
    }
  }

  Future<void> setDouble(String key, double value) async {
    try {
      await _prefs.setDouble(key, value);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (e) {
      throw CacheException.readError(key);
    }
  }

  Future<void> setBool(String key, bool value) async {
    try {
      await _prefs.setBool(key, value);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (e) {
      throw CacheException.readError(key);
    }
  }

  Future<void> setStringListJson(String key, List<Map<String, dynamic>> value) async {
    try {
      final jsonString = jsonEncode(value);
      await _prefs.setString(key, jsonString);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  List<Map<String, dynamic>>? getStringListJson(String key) {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      final List<dynamic> jsonList = jsonDecode(jsonString);
      return jsonList.cast<Map<String, dynamic>>();
    } catch (e) {
      throw CacheException.corruptedData(key);
    }
  }

  Future<void> setJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      await _prefs.setString(key, jsonString);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  Map<String, dynamic>? getJson(String key) {
    try {
      final jsonString = _prefs.getString(key);
      if (jsonString == null) return null;

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException.corruptedData(key);
    }
  }

  Future<void> remove(String key) async {
    try {
      await _prefs.remove(key);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  Future<void> clear() async {
    try {
      await _prefs.clear();
    } catch (e) {
      throw const CacheException('Failed to clear cache', code: 'CLEAR_ERROR');
    }
  }

  bool containsKey(String key) {
    return _prefs.containsKey(key);
  }

  Future<void> reload() async {
    try {
      await _prefs.reload();
    } catch (e) {
      throw const CacheException('Failed to reload cache', code: 'RELOAD_ERROR');
    }
  }

  // Secure Storage methods
  Future<void> setSecureString(String key, String value) async {
    try {
      await _secureStorage.write(key: key, value: value);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  Future<String?> getSecureString(String key) async {
    try {
      return await _secureStorage.read(key: key);
    } catch (e) {
      throw CacheException.readError(key);
    }
  }

  Future<void> setSecureJson(String key, Map<String, dynamic> value) async {
    try {
      final jsonString = jsonEncode(value);
      await _secureStorage.write(key: key, value: jsonString);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  Future<Map<String, dynamic>?> getSecureJson(String key) async {
    try {
      final jsonString = await _secureStorage.read(key: key);
      if (jsonString == null) return null;

      return jsonDecode(jsonString) as Map<String, dynamic>;
    } catch (e) {
      throw CacheException.corruptedData(key);
    }
  }

  Future<void> removeSecure(String key) async {
    try {
      await _secureStorage.delete(key: key);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  Future<void> clearSecure() async {
    try {
      await _secureStorage.deleteAll();
    } catch (e) {
      throw const CacheException('Failed to clear secure storage', code: 'CLEAR_SECURE_ERROR');
    }
  }

  Future<bool> containsSecureKey(String key) async {
    try {
      return await _secureStorage.containsKey(key: key);
    } catch (e) {
      return false;
    }
  }

  // File storage methods
  Future<File> getLocalFile(String fileName) async {
    return File('${_appDocumentsDir.path}/$fileName');
  }

  Future<File> getTempFile(String fileName) async {
    return File('${_appTempDir.path}/$fileName');
  }

  Future<void> writeToFile(File file, String content) async {
    try {
      await file.writeAsString(content);
    } catch (e) {
      throw CacheException.writeError(file.path);
    }
  }

  Future<String> readFromFile(File file) async {
    try {
      return await file.readAsString();
    } catch (e) {
      throw CacheException.readError(file.path);
    }
  }

  Future<void> writeBytesToFile(File file, List<int> bytes) async {
    try {
      await file.writeAsBytes(bytes);
    } catch (e) {
      throw CacheException.writeError(file.path);
    }
  }

  Future<List<int>> readBytesFromFile(File file) async {
    try {
      return await file.readAsBytes();
    } catch (e) {
      throw CacheException.readError(file.path);
    }
  }

  Future<bool> fileExists(File file) async {
    try {
      return await file.exists();
    } catch (e) {
      return false;
    }
  }

  Future<void> deleteFile(File file) async {
    try {
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      throw CacheException.writeError(file.path);
    }
  }

  Future<Directory> createDirectory(String dirName) async {
    try {
      final dir = Directory('${_appDocumentsDir.path}/$dirName');
      if (!await dir.exists()) {
        await dir.create(recursive: true);
      }
      return dir;
    } catch (e) {
      throw CacheException.writeError(dirName);
    }
  }

  Future<List<File>> getFilesInDirectory(Directory directory, {String extension = ''}) async {
    try {
      final files = <File>[];
      await for (final entity in directory.list()) {
        if (entity is File) {
          if (extension.isEmpty || entity.path.endsWith(extension)) {
            files.add(entity);
          }
        }
      }
      return files;
    } catch (e) {
      throw CacheException.readError(directory.path);
    }
  }

  Future<int> getDirectorySize(Directory directory) async {
    try {
      int totalSize = 0;
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
      return totalSize;
    } catch (e) {
      throw CacheException.readError(directory.path);
    }
  }

  Future<void> clearDirectory(Directory directory) async {
    try {
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        await directory.create();
      }
    } catch (e) {
      throw CacheException.writeError(directory.path);
    }
  }

  // Cache management methods
  Future<void> cacheData(String key, dynamic data, {Duration? expiration}) async {
    try {
      final cacheData = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'expiration': expiration?.millisecondsSinceEpoch,
      };
      await setJson(key, cacheData);
    } catch (e) {
      throw CacheException.writeError(key);
    }
  }

  Future<T?> getCachedData<T>(String key) async {
    try {
      final cacheData = getJson(key);
      if (cacheData == null) return null;

      final timestamp = cacheData['timestamp'] as int;
      final expiration = cacheData['expiration'] as int?;

      if (expiration != null && DateTime.now().millisecondsSinceEpoch > expiration) {
        await remove(key);
        return null;
      }

      return cacheData['data'] as T?;
    } catch (e) {
      throw CacheException.readError(key);
    }
  }

  Future<void> clearExpiredCache() async {
    try {
      final keys = _prefs.getKeys();
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      for (final key in keys) {
        if (key.startsWith('cache_')) {
          final cacheData = getJson(key);
          if (cacheData != null) {
            final expiration = cacheData['expiration'] as int?;
            if (expiration != null && currentTime > expiration) {
              await remove(key);
            }
          }
        }
      }
    } catch (e) {
      throw const CacheException('Failed to clear expired cache', code: 'CLEAR_EXPIRED_ERROR');
    }
  }

  // User session methods
  Future<void> saveUserSession(Map<String, dynamic> userData) async {
    try {
      await setJson(AppConstants.userKey, userData);
      await setSecureString(AppConstants.tokenKey, userData['token'] ?? '');
      await setString(AppConstants.roleKey, userData['role'] ?? '');
      await setBool(AppConstants.firstLaunchKey, false);
    } catch (e) {
      throw const CacheException('Failed to save user session', code: 'SESSION_SAVE_ERROR');
    }
  }

  Map<String, dynamic>? getUserSession() {
    try {
      return getJson(AppConstants.userKey);
    } catch (e) {
      return null;
    }
  }

  Future<String?> getUserToken() async {
    try {
      return await getSecureString(AppConstants.tokenKey);
    } catch (e) {
      return null;
    }
  }

  String? getUserRole() {
    try {
      return getString(AppConstants.roleKey);
    } catch (e) {
      return null;
    }
  }

  Future<void> clearUserSession() async {
    try {
      await remove(AppConstants.userKey);
      await removeSecure(AppConstants.tokenKey);
      await remove(AppConstants.roleKey);
      await remove(AppConstants.lastSyncKey);
    } catch (e) {
      throw const CacheException('Failed to clear user session', code: 'SESSION_CLEAR_ERROR');
    }
  }

  bool isFirstLaunch() {
    return getBool(AppConstants.firstLaunchKey) ?? true;
  }

  Future<void> setFirstLaunchCompleted() async {
    await setBool(AppConstants.firstLaunchKey, false);
  }

  // App settings methods
  Future<void> saveThemeMode(String themeMode) async {
    await setString(AppConstants.themeKey, themeMode);
  }

  String? getThemeMode() {
    return getString(AppConstants.themeKey);
  }

  Future<void> saveLanguage(String languageCode) async {
    await setString(AppConstants.languageKey, languageCode);
  }

  String? getLanguage() {
    return getString(AppConstants.languageKey);
  }

  // Sync methods
  Future<void> saveLastSyncTime() async {
    await setInt(AppConstants.lastSyncKey, DateTime.now().millisecondsSinceEpoch);
  }

  DateTime? getLastSyncTime() {
    final timestamp = getInt(AppConstants.lastSyncKey);
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp);
  }

  // Search history methods
  Future<void> addToSearchHistory(String query) async {
    final history = getStringList(AppConstants.searchHistory) ?? [];
    history.remove(query); // Remove if exists
    history.insert(0, query); // Add to beginning
    if (history.length > 10) {
      history.removeLast(); // Keep only last 10
    }
    await setStringList(AppConstants.searchHistory, history);
  }

  List<String> getSearchHistory() {
    return getStringList(AppConstants.searchHistory) ?? [];
  }

  Future<void> clearSearchHistory() async {
    await remove(AppConstants.searchHistory);
  }

  // Statistics and monitoring
  Future<Map<String, dynamic>> getCacheStatistics() async {
    try {
      final keys = _prefs.getKeys();
      int totalSize = 0;
      int totalEntries = 0;
      int expiredEntries = 0;
      final currentTime = DateTime.now().millisecondsSinceEpoch;

      for (final key in keys) {
        final value = _prefs.get(key);
        totalEntries++;

        // Estimate size based on string length
        if (value is String) {
          totalSize += value.length;
        } else if (value is List<String>) {
          totalSize += value.fold(0, (sum, item) => sum + item.length);
        }

        // Check for expired cache entries
        if (key.startsWith('cache_')) {
          final cacheData = getJson(key);
          if (cacheData != null) {
            final expiration = cacheData['expiration'] as int?;
            if (expiration != null && currentTime > expiration) {
              expiredEntries++;
            }
          }
        }
      }

      return {
        'totalEntries': totalEntries,
        'totalSizeBytes': totalSize,
        'expiredEntries': expiredEntries,
        'averageEntrySize': totalEntries > 0 ? totalSize / totalEntries : 0,
        'documentsDirectory': _appDocumentsDir.path,
        'tempDirectory': _appTempDir.path,
      };
    } catch (e) {
      throw const CacheException('Failed to get cache statistics', code: 'STATISTICS_ERROR');
    }
  }

  Future<void> optimizeCache() async {
    try {
      await clearExpiredCache();

      // Clean up temp files
      if (await _appTempDir.exists()) {
        await clearDirectory(_appTempDir);
      }
    } catch (e) {
      throw const CacheException('Failed to optimize cache', code: 'OPTIMIZE_ERROR');
    }
  }
}