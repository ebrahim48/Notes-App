import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _dataSource;

  AuthRepositoryImpl({required AuthRemoteDataSource dataSource})
      : _dataSource = dataSource;

  @override
  UserEntity? get currentUser => _dataSource.currentUser;

  @override
  Stream<UserEntity?> get authStateChanges => _dataSource.authStateChanges;

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    return await _dataSource.login(email: email, password: password);
  }

  @override
  Future<UserEntity> register({
    required String name,
    required String email,
    required String password,
  }) async {
    return await _dataSource.register(
        name: name, email: email, password: password);
  }

  @override
  Future<void> logout() async {
    await _dataSource.logout();
  }
}
