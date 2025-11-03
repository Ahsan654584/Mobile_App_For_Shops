import 'package:injectable/injectable.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../services/firebase_service.dart';
import '../../services/local_storage_service.dart';
import '../../core/utils/constants.dart';

@singleton
class UserRepository {
  final FirebaseService _firebaseService;
  final LocalStorageService _localStorageService;

  UserRepository(this._firebaseService, this._localStorageService);

  Future<User?> getUserById(String userId) async {
    try {
      final userDoc = await _firebaseService.getDocument(
        AppConstants.usersCollection,
        userId,
      );

      if (!userDoc.exists) return null;

      final userData = userDoc.data() as Map<String, dynamic>;
      return User.fromJson(userData);
    } catch (e) {
      return null;
    }
  }

  Future<List<User>> getAllUsers() async {
    try {
      final usersSnapshot = await _firebaseService.getCollection(
        AppConstants.usersCollection,
      );

      return usersSnapshot.docs
          .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<List<User>> getUsersByRole(String role) async {
    try {
      final usersSnapshot = await _firebaseService.getCollection(
        AppConstants.usersCollection,
      );

      return usersSnapshot.docs
          .map((doc) => User.fromJson(doc.data() as Map<String, dynamic>))
          .where((user) => user.role == role)
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<User?> updateUser(User user) async {
    try {
      await _firebaseService.updateDocument(
        AppConstants.usersCollection,
        user.id,
        user.toJson(),
      );

      return user;
    } catch (e) {
      return null;
    }
  }

  Future<bool> deleteUser(String userId) async {
    try {
      await _firebaseService.deleteDocument(
        AppConstants.usersCollection,
        userId,
      );
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<User>> searchUsers(String query) async {
    try {
      final allUsers = await getAllUsers();

      return allUsers.where((user) {
        return user.name.toLowerCase().contains(query.toLowerCase()) ||
               user.email.toLowerCase().contains(query.toLowerCase());
      }).toList();
    } catch (e) {
      return [];
    }
  }

  Future<User?> getCurrentUser() async {
    try {
      final userId = _firebaseService.currentUserId;
      if (userId == null) return null;

      return await getUserById(userId);
    } catch (e) {
      return null;
    }
  }

  Future<bool> isUserActive(String userId) async {
    try {
      final user = await getUserById(userId);
      return user?.isActive ?? false;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateLastLogin(String userId) async {
    try {
      await _firebaseService.updateDocument(
        AppConstants.usersCollection,
        userId,
        {'lastLoginAt': DateTime.now().toIso8601String()},
      );
    } catch (e) {
      // Ignore errors updating last login
    }
  }
}