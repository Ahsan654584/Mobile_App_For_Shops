import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../core/error/exceptions.dart';
import '../core/utils/constants.dart';

@singleton
class FirebaseService {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Firebase Auth methods
  auth.User? get currentUser => _auth.currentUser;

  Stream<auth.User?> get authStateChanges => _auth.authStateChanges();

  bool get isUserLoggedIn => _auth.currentUser != null;

  String? get currentUserId => _auth.currentUser?.uid;

  Future<auth.User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!;
    } on auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw FirebaseException('Failed to sign in: $e');
    }
  }

  Future<auth.User> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user!;
    } on auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw FirebaseException('Failed to create user: $e');
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw FirebaseException('Failed to send password reset email: $e');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw FirebaseException('Failed to sign out: $e');
    }
  }

  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.updatePhotoURL(photoURL);
    } on auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw FirebaseException('Failed to update profile: $e');
    }
  }

  Future<String> getIdToken() async {
    try {
      return await _auth.currentUser!.getIdToken();
    } on auth.FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw FirebaseException('Failed to get ID token: $e');
    }
  }

  // Firestore methods
  Future<DocumentSnapshot> getDocument(String collectionPath, String documentId) async {
    try {
      return await _firestore.collection(collectionPath).doc(documentId).get();
    } on FirebaseException catch (e) {
      throw _handleFirestoreException(e);
    } catch (e) {
      throw FirebaseException('Failed to get document: $e');
    }
  }

  Future<QuerySnapshot> getCollection(String collectionPath, {
    Query? query,
    int? limit,
    DocumentSnapshot? startAfter,
    String? orderBy,
    bool descending = false,
  }) async {
    try {
      Query collectionQuery = _firestore.collection(collectionPath);

      if (query != null) {
        collectionQuery = query;
      } else {
        if (orderBy != null) {
          collectionQuery = collectionQuery.orderBy(orderBy, descending: descending);
        }
        if (startAfter != null) {
          collectionQuery = collectionQuery.startAfterDocument(startAfter);
        }
        if (limit != null) {
          collectionQuery = collectionQuery.limit(limit);
        }
      }

      return await collectionQuery.get();
    } on FirebaseException catch (e) {
      throw _handleFirestoreException(e);
    } catch (e) {
      throw FirebaseException('Failed to get collection: $e');
    }
  }

  Future<DocumentReference> setDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      final docRef = _firestore.collection(collectionPath).doc(documentId);
      await docRef.set(data);
      return docRef;
    } on FirebaseException catch (e) {
      throw _handleFirestoreException(e);
    } catch (e) {
      throw FirebaseException('Failed to set document: $e');
    }
  }

  Future<DocumentReference> updateDocument(
    String collectionPath,
    String documentId,
    Map<String, dynamic> data,
  ) async {
    try {
      final docRef = _firestore.collection(collectionPath).doc(documentId);
      await docRef.update(data);
      return docRef;
    } on FirebaseException catch (e) {
      throw _handleFirestoreException(e);
    } catch (e) {
      throw FirebaseException('Failed to update document: $e');
    }
  }

  Future<void> deleteDocument(String collectionPath, String documentId) async {
    try {
      await _firestore.collection(collectionPath).doc(documentId).delete();
    } on FirebaseException catch (e) {
      throw _handleFirestoreException(e);
    } catch (e) {
      throw FirebaseException('Failed to delete document: $e');
    }
  }

  Stream<QuerySnapshot> getCollectionStream(
    String collectionPath, {
    Query? query,
    int? limit,
    String? orderBy,
    bool descending = false,
  }) {
    try {
      Query collectionQuery = _firestore.collection(collectionPath);

      if (query != null) {
        collectionQuery = query;
      } else {
        if (orderBy != null) {
          collectionQuery = collectionQuery.orderBy(orderBy, descending: descending);
        }
        if (limit != null) {
          collectionQuery = collectionQuery.limit(limit);
        }
      }

      return collectionQuery.snapshots();
    } catch (e) {
      throw FirebaseException('Failed to create collection stream: $e');
    }
  }

  Stream<DocumentSnapshot> getDocumentStream(String collectionPath, String documentId) {
    try {
      return _firestore.collection(collectionPath).doc(documentId).snapshots();
    } catch (e) {
      throw FirebaseException('Failed to create document stream: $e');
    }
  }

  // Firebase Storage methods
  Future<String> uploadFile(
    String filePath,
    File file, {
    Map<String, String>? metadata,
  }) async {
    try {
      final ref = _storage.ref().child(filePath);
      final uploadTask = await ref.putFile(file);

      if (metadata != null) {
        await ref.updateMetadata(FullMetadata(
          customMetadata: metadata,
        ));
      }

      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw _handleStorageException(e);
    } catch (e) {
      throw FirebaseException('Failed to upload file: $e');
    }
  }

  Future<String> uploadData(
    String filePath,
    Uint8List data, {
    Map<String, String>? metadata,
  }) async {
    try {
      final ref = _storage.ref().child(filePath);
      final uploadTask = await ref.putData(data);

      if (metadata != null) {
        await ref.updateMetadata(FullMetadata(
          customMetadata: metadata,
        ));
      }

      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw _handleStorageException(e);
    } catch (e) {
      throw FirebaseException('Failed to upload data: $e');
    }
  }

  Future<Uint8List?> downloadFile(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      return await ref.getData();
    } on FirebaseException catch (e) {
      throw _handleStorageException(e);
    } catch (e) {
      throw FirebaseException('Failed to download file: $e');
    }
  }

  Future<String> getDownloadUrl(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      return await ref.getDownloadURL();
    } on FirebaseException catch (e) {
      throw _handleStorageException(e);
    } catch (e) {
      throw FirebaseException('Failed to get download URL: $e');
    }
  }

  Future<void> deleteFile(String filePath) async {
    try {
      final ref = _storage.ref().child(filePath);
      await ref.delete();
    } on FirebaseException catch (e) {
      throw _handleStorageException(e);
    } catch (e) {
      throw FirebaseException('Failed to delete file: $e');
    }
  }

  Future<ListResult> listFiles(String directoryPath) async {
    try {
      final ref = _storage.ref().child(directoryPath);
      return await ref.listAll();
    } on FirebaseException catch (e) {
      throw _handleStorageException(e);
    } catch (e) {
      throw FirebaseException('Failed to list files: $e');
    }
  }

  // Batch operations for Firestore
  Future<void> batchWrite(List<BatchOperation> operations) async {
    try {
      final batch = _firestore.batch();

      for (final operation in operations) {
        switch (operation.type) {
          case BatchOperationType.set:
            batch.set(
              _firestore.collection(operation.collectionPath).doc(operation.documentId),
              operation.data!,
            );
            break;
          case BatchOperationType.update:
            batch.update(
              _firestore.collection(operation.collectionPath).doc(operation.documentId),
              operation.data!,
            );
            break;
          case BatchOperationType.delete:
            batch.delete(
              _firestore.collection(operation.collectionPath).doc(operation.documentId),
            );
            break;
        }
      }

      await batch.commit();
    } on FirebaseException catch (e) {
      throw _handleFirestoreException(e);
    } catch (e) {
      throw FirebaseException('Failed to execute batch operation: $e');
    }
  }

  // Transaction operations
  Future<T> runTransaction<T>(
    T Function(Transaction transaction) transactionHandler,
  ) async {
    try {
      return await _firestore.runTransaction(transactionHandler);
    } on FirebaseException catch (e) {
      throw _handleFirestoreException(e);
    } catch (e) {
      throw FirebaseException('Failed to run transaction: $e');
    }
  }

  // Exception handlers
  FirebaseException _handleAuthException(auth.FirebaseAuthException e) {
    return FirebaseException.fromCode(e.code, e.message);
  }

  FirebaseException _handleFirestoreException(FirebaseException e) {
    switch (e.code) {
      case 'permission-denied':
        return const FirebaseException(
          'You do not have permission to perform this operation.',
          code: 'PERMISSION_DENIED',
        );
      case 'not-found':
        return const FirebaseException(
          'The requested document was not found.',
          code: 'NOT_FOUND',
        );
      case 'already-exists':
        return const FirebaseException(
          'The document already exists.',
          code: 'ALREADY_EXISTS',
        );
      case 'resource-exhausted':
        return const FirebaseException(
          'Resource quota exceeded.',
          code: 'RESOURCE_EXHAUSTED',
        );
      case 'failed-precondition':
        return const FirebaseException(
          'Operation was rejected due to the current state of the system.',
          code: 'FAILED_PRECONDITION',
        );
      case 'aborted':
        return const FirebaseException(
          'The operation was aborted.',
          code: 'ABORTED',
        );
      case 'out-of-range':
        return const FirebaseException(
          'Operation was attempted past the valid range.',
          code: 'OUT_OF_RANGE',
        );
      case 'unimplemented':
        return const FirebaseException(
          'Operation is not implemented or not supported.',
          code: 'UNIMPLEMENTED',
        );
      case 'internal':
        return const FirebaseException(
          'Internal server error.',
          code: 'INTERNAL',
        );
      case 'unavailable':
        return const FirebaseException(
          'Service is currently unavailable.',
          code: 'UNAVAILABLE',
        );
      case 'data-loss':
        return const FirebaseException(
          'Unrecoverable data loss or corruption.',
          code: 'DATA_LOSS',
        );
      case 'unauthenticated':
        return const FirebaseException(
          'You are not authenticated. Please sign in.',
          code: 'UNAUTHENTICATED',
        );
      default:
        return FirebaseException(
          e.message ?? 'An unknown Firestore error occurred.',
          code: e.code,
        );
    }
  }

  FirebaseException _handleStorageException(FirebaseException e) {
    switch (e.code) {
      case 'object-not-found':
        return const FirebaseException(
          'The requested file was not found.',
          code: 'OBJECT_NOT_FOUND',
        );
      case 'bucket-not-found':
        return const FirebaseException(
          'No bucket is configured for Firebase Storage.',
          code: 'BUCKET_NOT_FOUND',
        );
      case 'project-not-found':
        return const FirebaseException(
          'No project is configured for Firebase Storage.',
          code: 'PROJECT_NOT_FOUND',
        );
      case 'quota-exceeded':
        return const FirebaseException(
          'Storage quota has been exceeded.',
          code: 'QUOTA_EXCEEDED',
        );
      case 'unauthenticated':
        return const FirebaseException(
          'You are not authenticated. Please sign in.',
          code: 'UNAUTHENTICATED',
        );
      case 'unauthorized':
        return const FirebaseException(
          'You do not have permission to access this file.',
          code: 'UNAUTHORIZED',
        );
      case 'retry-limit-exceeded':
        return const FirebaseException(
          'The maximum time limit on an operation has been exceeded.',
          code: 'RETRY_LIMIT_EXCEEDED',
        );
      case 'invalid-checksum':
        return const FirebaseException(
          'The uploaded file does not match the checksum.',
          code: 'INVALID_CHECKSUM',
        );
      case 'canceled':
        return const FirebaseException(
          'The operation was cancelled.',
          code: 'CANCELED',
        );
      default:
        return FirebaseException(
          e.message ?? 'An unknown storage error occurred.',
          code: e.code,
        );
    }
  }

  // Utility methods
  bool isNetworkException(Exception exception) {
    if (exception is FirebaseException) {
      return [
        'unavailable',
        'deadline-exceeded',
        'INTERNAL',
        'unknown',
      ].contains(exception.code);
    }
    return false;
  }

  bool isAuthException(Exception exception) {
    if (exception is FirebaseException) {
      return [
        'user-not-found',
        'wrong-password',
        'email-already-in-use',
        'weak-password',
        'invalid-email',
        'user-disabled',
        'too-many-requests',
        'operation-not-allowed',
        'unauthenticated',
        'UNAUTHENTICATED',
      ].contains(exception.code);
    }
    return false;
  }

  bool isPermissionException(Exception exception) {
    if (exception is FirebaseException) {
      return [
        'permission-denied',
        'unauthorized',
        'PERMISSION_DENIED',
      ].contains(exception.code);
    }
    return false;
  }
}

class BatchOperation {
  final BatchOperationType type;
  final String collectionPath;
  final String documentId;
  final Map<String, dynamic>? data;

  BatchOperation({
    required this.type,
    required this.collectionPath,
    required this.documentId,
    this.data,
  });
}

enum BatchOperationType {
  set,
  update,
  delete,
}