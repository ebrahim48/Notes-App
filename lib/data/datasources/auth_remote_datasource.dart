import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../../core/constants/app_constants.dart';

abstract class AuthRemoteDataSource {
  UserModel? get currentUser;
  Stream<UserModel?> get authStateChanges;
  Future<UserModel> login({required String email, required String password});
  Future<UserModel> register(
      {required String name,
      required String email,
      required String password});
  Future<void> logout();
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRemoteDataSourceImpl({
    required FirebaseAuth firebaseAuth,
    required FirebaseFirestore firestore,
  })  : _firebaseAuth = firebaseAuth,
        _firestore = firestore;

  @override
  UserModel? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return UserModel(
        uid: user.uid, email: user.email ?? '', name: user.displayName ?? '');
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(user.uid)
          .get();
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.data()!);
      }
      return UserModel(
          uid: user.uid,
          email: user.email ?? '',
          name: user.displayName ?? '');
    });
  }

  @override
  Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;
    final doc = await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .get();
    if (doc.exists && doc.data() != null) {
      return UserModel.fromMap(doc.data()!);
    }
    return UserModel(
        uid: user.uid, email: user.email ?? '', name: user.displayName ?? '');
  }

  @override
  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = credential.user!;
    await user.updateDisplayName(name.trim());
    final userModel = UserModel(
      uid: user.uid,
      email: user.email ?? '',
      name: name.trim(),
    );
    await _firestore
        .collection(AppConstants.usersCollection)
        .doc(user.uid)
        .set(userModel.toMap());
    return userModel;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
