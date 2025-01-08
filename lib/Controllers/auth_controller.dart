import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vocal_lens/Helper/firebase_helper.dart';

class AuthController extends ChangeNotifier {
  final AuthHelper _authHelper = AuthHelper();
  User? _user;

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  Future<void> signInWithEmail(String email, String password) async {
    try {
      _user = await _authHelper.signInWithEmail(email, password);
      notifyListeners();
    } catch (e) {
      throw Exception("Error during email sign-in: $e");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _user = await _authHelper.signInWithGoogle();
      notifyListeners();
    } catch (e) {
      throw Exception("Error during Google sign-in: $e");
    }
  }

  Future<void> signOut() async {
    await _authHelper.signOut();
    _user = null;
    notifyListeners();
  }

  User? getCurrentUser() {
    _user = _authHelper.getCurrentUser();
    return _user;
  }
}
