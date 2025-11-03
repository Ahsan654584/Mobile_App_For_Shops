import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/error/failures.dart';
import '../../../../services/firebase_service.dart';
import '../../../../services/local_storage_service.dart';
import '../../../../core/utils/constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseService _firebaseService;
  final LocalStorageService _localStorageService;

  AuthRepositoryImpl(
    this._firebaseService,
    this._localStorageService,
  );

  @override
  Future<Either<Failure, User>> login({
    required String email,
    required String password,
    required bool rememberMe,
  }) async {
    try {
      // Sign in with Firebase Auth
      final firebaseUser = await _firebaseService.signInWithEmailAndPassword(
        email,
        password,
      );

      // Get user data from Firestore
      final userDoc = await _firebaseService.getDocument(
        AppConstants.usersCollection,
        firebaseUser.uid,
      );

      if (!userDoc.exists) {
        return Left(const AuthFailure.userNotFound());
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final user = User.fromJson(userData);

      // Save user session locally if remember me is checked
      if (rememberMe) {
        await _localStorageService.saveUserSession(user.toJson());
        final token = await _firebaseService.getIdToken();
        await _localStorageService.setSecureString(
          AppConstants.tokenKey,
          token,
        );
      }

      // Update last login time
      await _updateLastLogin(user.id);

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> register({
    required String email,
    required String password,
    required String name,
    required String role,
  }) async {
    try {
      // Create user with Firebase Auth
      final firebaseUser = await _firebaseService.createUserWithEmailAndPassword(
        email,
        password,
      );

      // Create user document in Firestore
      final userData = User(
        id: firebaseUser.uid,
        email: email,
        name: name,
        role: role,
        createdAt: DateTime.now(),
      ).toJson();

      await _firebaseService.setDocument(
        AppConstants.usersCollection,
        firebaseUser.uid,
        userData,
      );

      // Update profile display name
      await _firebaseService.updateProfile(displayName: name);

      final user = User.fromJson(userData);

      // Save user session locally
      await _localStorageService.saveUserSession(user.toJson());
      final token = await _firebaseService.getIdToken();
      await _localStorageService.setSecureString(
        AppConstants.tokenKey,
        token,
      );

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _firebaseService.signOut();
      await _localStorageService.clearUserSession();
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> checkAuthStatus() async {
    try {
      final firebaseUser = _firebaseService.currentUser;
      if (firebaseUser == null) {
        return const Left(AuthFailure.sessionExpired());
      }

      // Check if we have saved session data locally
      final savedUserData = _localStorageService.getUserSession();
      if (savedUserData != null) {
        final user = User.fromJson(savedUserData);

        // Verify the user still exists in Firestore and update data
        final userDoc = await _firebaseService.getDocument(
          AppConstants.usersCollection,
          user.id,
        );

        if (userDoc.exists) {
          final updatedUserData = userDoc.data() as Map<String, dynamic>;
          final updatedUser = User.fromJson(updatedUserData);

          // Update local session with fresh data
          await _localStorageService.saveUserSession(updatedUser.toJson());

          return Right(updatedUser);
        }
      }

      // Fallback: get user data from Firestore
      final userDoc = await _firebaseService.getDocument(
        AppConstants.usersCollection,
        firebaseUser.uid,
      );

      if (!userDoc.exists) {
        return const Left(AuthFailure.userNotFound());
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final user = User.fromJson(userData);

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordResetEmail(String email) async {
    try {
      await _firebaseService.sendPasswordResetEmail(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword({
    required String code,
    required String newPassword,
  }) async {
    try {
      // This would typically be implemented with Firebase Auth's confirmPasswordReset
      // For now, we'll return an error
      return const Left(AuthFailure('Password reset not implemented yet'));
    } catch (e) {
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      final firebaseUser = _firebaseService.currentUser;
      if (firebaseUser == null) {
        return const Left(AuthFailure.unauthorized());
      }

      // Re-authenticate user with current password
      final credential = auth.EmailAuthProvider.credential(
        email: firebaseUser.email!,
        password: currentPassword,
      );

      await firebaseUser.reauthenticateWithCredential(credential);
      await firebaseUser.updatePassword(newPassword);

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> updateProfile({
    String? displayName,
    String? phoneNumber,
    String? photoURL,
  }) async {
    try {
      final firebaseUser = _firebaseService.currentUser;
      if (firebaseUser == null) {
        return const Left(AuthFailure.unauthorized());
      }

      // Update Firebase Auth profile
      await _firebaseService.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );

      // Update Firestore document
      final updateData = <String, dynamic>{};
      if (displayName != null) updateData['name'] = displayName;
      if (phoneNumber != null) updateData['phoneNumber'] = phoneNumber;
      if (photoURL != null) updateData['photoURL'] = photoURL;

      if (updateData.isNotEmpty) {
        await _firebaseService.updateDocument(
          AppConstants.usersCollection,
          firebaseUser.uid,
          updateData,
        );
      }

      // Get updated user data
      final userDoc = await _firebaseService.getDocument(
        AppConstants.usersCollection,
        firebaseUser.uid,
      );

      final userData = userDoc.data() as Map<String, dynamic>;
      final user = User.fromJson(userData);

      // Update local session
      await _localStorageService.saveUserSession(user.toJson());

      return Right(user);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> refreshToken() async {
    try {
      final token = await _firebaseService.getIdToken();
      await _localStorageService.setSecureString(
        AppConstants.tokenKey,
        token,
      );
      return Right(token);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount() async {
    try {
      final firebaseUser = _firebaseService.currentUser;
      if (firebaseUser == null) {
        return const Left(AuthFailure.unauthorized());
      }

      // Delete user document from Firestore
      await _firebaseService.deleteDocument(
        AppConstants.usersCollection,
        firebaseUser.uid,
      );

      // Delete Firebase Auth user
      await firebaseUser.delete();

      // Clear local session
      await _localStorageService.clearUserSession();

      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } on FirebaseException catch (e) {
      return Left(FirebaseFailure(e.message, code: e.code));
    } catch (e) {
      return Left(UnknownFailure.unexpected(e.toString()));
    }
  }

  @override
  String? getCurrentUserId() {
    return _firebaseService.currentUserId;
  }

  @override
  Stream<bool> get authStateChanges {
    return _firebaseService.authStateChanges.map((user) => user != null);
  }

  @override
  bool hasPermission(String permission) {
    final role = _localStorageService.getUserRole();
    if (role == null) return false;

    switch (role) {
      case AppConstants.adminRole:
        return true; // Admin has all permissions
      case AppConstants.distributorRole:
        return [
          'read:products',
          'read:orders',
          'write:orders',
          'read:customers',
          'read:analytics',
        ].contains(permission);
      case AppConstants.customerRole:
        return [
          'read:products',
          'read:orders',
          'write:orders',
          'read:profile',
          'write:profile',
        ].contains(permission);
      default:
        return false;
    }
  }

  @override
  String? getUserRole() {
    return _localStorageService.getUserRole();
  }

  // Helper method to update last login time
  Future<void> _updateLastLogin(String userId) async {
    try {
      await _firebaseService.updateDocument(
        AppConstants.usersCollection,
        userId,
        {'lastLoginAt': DateTime.now().toIso8601String()},
      );
    } catch (e) {
      // Ignore errors updating last login time
    }
  }
}