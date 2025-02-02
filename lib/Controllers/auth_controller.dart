import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vocal_lens/Helper/firebase_helper.dart';
import 'package:vocal_lens/Views/HomePage/home_page.dart';
import 'package:vocal_lens/Views/LoginPage/login_page.dart';

class AuthController extends ChangeNotifier {
  final AuthHelper _authHelper = AuthHelper();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  User? _user;

  User? get user => _user;

  bool get isAuthenticated => _user != null;

  // Constructor to initialize the current user
  AuthController() {
    _user = FirebaseAuth.instance.currentUser;
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      _user = await _authHelper.signInWithEmail(email, password);
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception("No user found with this email.");
      } else if (e.code == 'wrong-password') {
        throw Exception("Incorrect password provided.");
      } else if (e.code == 'invalid-email') {
        throw Exception("Invalid email address format.");
      } else {
        throw Exception("Authentication error: ${e.message}");
      }
    } catch (e) {
      throw Exception("Unexpected error during email sign-in: $e");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _user = await _authHelper.signInWithGoogle();
      Flexify.goRemove(
        const HomePage(),
        animation: FlexifyRouteAnimations.blur,
        duration: Durations.medium1,
      );
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      throw Exception("Google sign-in error: ${e.message}");
    } catch (e) {
      throw Exception("Unexpected error during Google sign-in: $e");
    }
  }

  Future<void> signOut() async {
    try {
      await _authHelper.signOut();
      _user = null;
      Flexify.goRemove(
        const LoginPage(),
        animation: FlexifyRouteAnimations.blur,
        duration: Durations.medium1,
      );
      notifyListeners();
    } catch (e) {
      throw Exception("Error signing out: $e");
    }
  }

  User? getCurrentUser() {
    _user = FirebaseAuth.instance.currentUser;
    return _user;
  }


  Future<void> updateDisplayName({required String displayName}) async {
    if (_user == null) {
      throw Exception("User is not authenticated. Please sign in first.");
    }

    try {
      await _user!.updateDisplayName(displayName);
      await _user!.reload();
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } catch (e) {
      throw Exception("Error updating display name: $e");
    }
  }

  Future<void> updateEmail({required String email}) async {
    if (_user == null) {
      throw Exception("User is not authenticated. Please sign in first.");
    }

    try {
      await _user!.verifyBeforeUpdateEmail(email);
      await _user!.reload();
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } catch (e) {
      throw Exception("Error updating email: $e");
    }
  }
}
