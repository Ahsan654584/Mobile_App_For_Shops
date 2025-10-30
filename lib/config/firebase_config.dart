import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../utils/logger.dart';

/// Firebase configuration and initialization
class FirebaseConfig {
  static final FirebaseConfig _instance = FirebaseConfig._internal();

  factory FirebaseConfig() {
    return _instance;
  }

  FirebaseConfig._internal();

  /// Initialize Firebase for the app
  static Future<void> initialize() async {
    try {
      await Firebase.initializeApp();

      // Enable offline persistence for Firestore
      FirebaseFirestore.instance.settings = const Settings(
        persistenceEnabled: true,
      );

      AppLogger.info('Firebase initialized successfully');
    } catch (e) {
      AppLogger.error('Firebase initialization error: $e');
      rethrow;
    }
  }

  /// Get Firestore instance
  static FirebaseFirestore getFirestore() {
    return FirebaseFirestore.instance;
  }
}
