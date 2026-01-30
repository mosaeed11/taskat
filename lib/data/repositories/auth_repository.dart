import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskat_new/data/models/user_model.dart';
import 'package:taskat_new/data/services/firebase_auth_service.dart';
import 'package:taskat_new/data/services/firebase_firestore_service.dart';
import 'package:taskat_new/providers/auth_provider.dart' as provider;

class AuthRepositoryImpl implements provider.AuthRepository {
  final FirebaseAuthService _firebaseAuthService;
  final FirebaseFirestoreService _firestoreService;

  AuthRepositoryImpl({
    required FirebaseAuthService firebaseAuthService,
    required FirebaseFirestoreService firebaseFirestoreService,
  })  : _firebaseAuthService = firebaseAuthService,
        _firestoreService = firebaseFirestoreService;

  @override
  Stream<User?> get authStateChanges => _firebaseAuthService.authStateChanges;

  @override
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuthService.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user != null) {
      return await _firestoreService.getUser(credential.user!.uid);
    }
    return null;
  }

  @override
  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _firebaseAuthService.registerWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (credential.user != null) {
      final newUser = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
      );
      await _firestoreService.createUser(newUser);
      return newUser;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    await _firebaseAuthService.signOut();
  }

  @override
  Future<UserModel?> getUserData(String uid) async {
    return await _firestoreService.getUser(uid);
  }
}
