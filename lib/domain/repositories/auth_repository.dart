import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Returns current signed-in user or null
  UserEntity? get currentUser;

  /// Stream of auth state changes
  Stream<UserEntity?> get authStateChanges;

  /// Login with email and password
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  /// Register with name, email and password
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  });

  /// Logout the current user
  Future<void> logout();
}
