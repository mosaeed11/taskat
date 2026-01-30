import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:taskat_new/data/models/user_model.dart';

abstract class AuthRepository {
  Stream<User?> get authStateChanges;

  Future<UserModel?> login({
    required String email,
    required String password,
  });

  Future<UserModel?> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<UserModel?> getUserData(String uid);
}

class AuthProvider extends ChangeNotifier {
  AuthRepository _authRepository;

  UserModel? _currentUser;
  bool _isLoading = false;
  bool _isInitialized = false;
  String? _errorMessage;

  StreamSubscription<User?>? _authSub;

  AuthProvider({required AuthRepository authRepository})
      : _authRepository = authRepository {
    _initAuthListener();
  }

  void setRepository(AuthRepository repo) {
    _authRepository = repo;
    _authSub?.cancel();
    _initAuthListener();
  }

  void _initAuthListener() {
    _authSub = _authRepository.authStateChanges.listen((User? user) async {
      if (user != null) {
        await _loadUserData(user.uid);
      } else {
        _currentUser = null;
      }
      _isInitialized = true;
      notifyListeners();
    });
  }

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isInitialized => _isInitialized;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;

  Future<void> _loadUserData(String uid) async {
    try {
      _currentUser = await _authRepository.getUserData(uid);
    } catch (e) {
      debugPrint('Error loading user data: $e');
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      _currentUser = await _authRepository.login(
        email: email,
        password: password,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      _currentUser = await _authRepository.register(
        name: name,
        email: email,
        password: password,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    _currentUser = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSub?.cancel();
    super.dispose();
  }
}
