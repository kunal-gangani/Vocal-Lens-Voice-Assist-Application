import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:vocal_lens/Helper/auth_helper.dart';
import 'package:vocal_lens/Views/HomePage/home_page.dart';
import 'package:vocal_lens/Views/LoginPage/login_page.dart';

class AuthController extends ChangeNotifier {
  final AuthHelper _authHelper = AuthHelper();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FlutterTts _flutterTts = FlutterTts();
  User? _user;

  AuthController() {
    _user = FirebaseAuth.instance.currentUser;
    _initializeTts();
  }

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  void _initializeTts() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setPitch(1.0);
  }

  String getWelcomeMessage() {
    return _user != null && _user!.displayName != null
        ? "Hello ${_user!.displayName}, welcome to Vocal Lens!"
        : "Welcome to Vocal Lens!";
  }

  Future<void> speakWelcomeMessage() async {
    await _flutterTts.speak(getWelcomeMessage());
  }

  Future<void> signInWithEmail(String email, String password) async {
    try {
      _user = await _authHelper.signInWithEmail(email, password);
      notifyListeners();
      speakWelcomeMessage();
    } on FirebaseAuthException catch (e) {
      throw Exception(_getAuthErrorMessage(e.code));
    } catch (e) {
      throw Exception("Unexpected error during email sign-in: $e");
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      _user = await _authHelper.signInWithGoogle();
      notifyListeners();
      speakWelcomeMessage();
      _navigateToHomePage();
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
      notifyListeners();
      _navigateToLoginPage();
    } catch (e) {
      throw Exception("Error signing out: $e");
    }
  }

  Future<void> updateDisplayName({required String displayName}) async {
    if (_user == null) throw Exception("User is not authenticated.");
    try {
      await _user!.updateDisplayName(displayName);
      await _refreshUser();
    } catch (e) {
      throw Exception("Error updating display name: $e");
    }
  }

  Future<void> updateEmail({required String email}) async {
    if (_user == null) throw Exception("User is not authenticated.");
    try {
      await _user!.verifyBeforeUpdateEmail(email);
      await _refreshUser();
    } catch (e) {
      throw Exception("Error updating email: $e");
    }
  }

  /// Refreshes the user object after updates.
  Future<void> _refreshUser() async {
    await _user!.reload();
    _user = FirebaseAuth.instance.currentUser;
    notifyListeners();
  }

  /// Returns user-friendly error messages.
  String _getAuthErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return "No user found with this email.";
      case 'wrong-password':
        return "Incorrect password provided.";
      case 'invalid-email':
        return "Invalid email address format.";
      default:
        return "Authentication error.";
    }
  }

  /// Navigates to the Home Page
  void _navigateToHomePage() {
    Flexify.goRemove(
      const HomePage(),
      animation: FlexifyRouteAnimations.blur,
      duration: Durations.medium1,
    );
  }

  /// Navigates to the Login Page
  void _navigateToLoginPage() {
    Flexify.goRemove(
      const LoginPage(),
      animation: FlexifyRouteAnimations.blur,
      duration: Durations.medium1,
    );
  }
}
