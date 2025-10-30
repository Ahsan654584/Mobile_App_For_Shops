import 'package:cloud_firestore/cloud_firestore.dart';
import '../config/app_config.dart';
import '../exceptions/db_exception.dart';
import '../utils/logger.dart';

/// Firestore database service
/// Placeholder for Cloud Firestore operations
class FirestoreService {
  static final FirestoreService _instance = FirestoreService._internal();
  late final FirebaseFirestore _db;

  factory FirestoreService() {
    return _instance;
  }

  FirestoreService._internal();

  /// Initialize Firestore service
  void initialize() {
    _db = FirebaseFirestore.instance;
    AppLogger.info('FirestoreService initialized');
  }

  /// Get reference to a collection
  CollectionReference<Map<String, dynamic>> getCollection(String collectionName) {
    return _db.collection(collectionName);
  }

  /// Create a document
  Future<void> createDocument({
    required String collectionName,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.info('Creating document: $collectionName/$docId');

      // Add timestamps
      final dataWithTimestamps = {
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _db.collection(collectionName).doc(docId).set(dataWithTimestamps);
      AppLogger.info('Document created successfully: $collectionName/$docId');
    } catch (e) {
      AppLogger.error('Error creating document', e);
      throw FirestoreException(
        message: 'Failed to create document',
        originalError: e,
      );
    }
  }

  /// Read a document
  Future<Map<String, dynamic>?> getDocument({
    required String collectionName,
    required String docId,
  }) async {
    try {
      AppLogger.debug('Fetching document: $collectionName/$docId');

      final doc = await _db.collection(collectionName).doc(docId).get();

      if (!doc.exists) {
        return null;
      }

      return doc.data();
    } catch (e) {
      AppLogger.error('Error reading document', e);
      throw FirestoreException(
        message: 'Failed to read document',
        originalError: e,
      );
    }
  }

  /// Update a document
  Future<void> updateDocument({
    required String collectionName,
    required String docId,
    required Map<String, dynamic> data,
  }) async {
    try {
      AppLogger.info('Updating document: $collectionName/$docId');

      // Add update timestamp
      final dataWithTimestamp = {
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      await _db.collection(collectionName).doc(docId).update(dataWithTimestamp);
      AppLogger.info('Document updated successfully: $collectionName/$docId');
    } catch (e) {
      AppLogger.error('Error updating document', e);
      throw FirestoreException(
        message: 'Failed to update document',
        originalError: e,
      );
    }
  }

  /// Delete a document
  Future<void> deleteDocument({
    required String collectionName,
    required String docId,
  }) async {
    try {
      AppLogger.info('Deleting document: $collectionName/$docId');

      await _db.collection(collectionName).doc(docId).delete();
      AppLogger.info('Document deleted successfully: $collectionName/$docId');
    } catch (e) {
      AppLogger.error('Error deleting document', e);
      throw FirestoreException(
        message: 'Failed to delete document',
        originalError: e,
      );
    }
  }

  /// Query documents from a collection
  Future<List<Map<String, dynamic>>> queryCollection({
    required String collectionName,
    int limit = 100,
  }) async {
    try {
      AppLogger.debug('Querying collection: $collectionName (limit: $limit)');

      final snapshot = await _db
          .collection(collectionName)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      AppLogger.error('Error querying collection', e);
      throw FirestoreException(
        message: 'Failed to query collection',
        originalError: e,
      );
    }
  }

  /// Listen to real-time updates from a collection
  Stream<List<Map<String, dynamic>>> streamCollection(String collectionName) {
    try {
      AppLogger.debug('Streaming collection: $collectionName');

      return _db.collection(collectionName).snapshots().map(
        (snapshot) {
          return snapshot.docs.map((doc) => doc.data()).toList();
        },
      ).onError((error, stackTrace) {
        AppLogger.error('Error streaming collection', error, stackTrace);
        throw FirestoreException(
          message: 'Failed to stream collection',
          originalError: error,
        );
      });
    } catch (e) {
      AppLogger.error('Error setting up collection stream', e);
      throw FirestoreException(
        message: 'Failed to setup collection stream',
        originalError: e,
      );
    }
  }

  /// Listen to real-time updates for a single document
  Stream<Map<String, dynamic>?> streamDocument({
    required String collectionName,
    required String docId,
  }) {
    try {
      AppLogger.debug('Streaming document: $collectionName/$docId');

      return _db.collection(collectionName).doc(docId).snapshots().map(
        (snapshot) {
          if (!snapshot.exists) {
            return null;
          }
          return snapshot.data();
        },
      ).onError((error, stackTrace) {
        AppLogger.error('Error streaming document', error, stackTrace);
        throw FirestoreException(
          message: 'Failed to stream document',
          originalError: error,
        );
      });
    } catch (e) {
      AppLogger.error('Error setting up document stream', e);
      throw FirestoreException(
        message: 'Failed to setup document stream',
        originalError: e,
      );
    }
  }

  /// Batch write operation
  Future<void> batchWrite({
    required String collectionName,
    required List<Map<String, dynamic>> documents,
  }) async {
    try {
      AppLogger.info('Starting batch write for collection: $collectionName');

      final batch = _db.batch();
      final collection = _db.collection(collectionName);

      for (final doc in documents) {
        final docId = doc['id'] as String;
        batch.set(collection.doc(docId), doc);
      }

      await batch.commit();
      AppLogger.info('Batch write completed: $collectionName (${documents.length} docs)');
    } catch (e) {
      AppLogger.error('Error in batch write', e);
      throw FirestoreException(
        message: 'Failed to perform batch write',
        originalError: e,
      );
    }
  }

  /// Get Firestore instance
  FirebaseFirestore get firestore => _db;
}
