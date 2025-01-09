import 'dart:io';
import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vocal_lens/Helper/firebase_helper.dart';
import 'package:vocal_lens/Views/LoginPage/login_page.dart';

class AuthController extends ChangeNotifier {
  final AuthHelper _authHelper = AuthHelper();
  final FirebaseStorage _storage = FirebaseStorage.instance;
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
    Flexify.goRemove(
      const LoginPage(),
      animation: FlexifyRouteAnimations.blur,
      duration: Durations.medium1,
    );
    notifyListeners();
  }

  User? getCurrentUser() {
    _user = _authHelper.getCurrentUser();
    return _user;
  }

  Future<void> updateProfilePicture() async {
    if (_user == null) return;

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
      );

      if (image == null) return;

      final File file = File(image.path);
      final ref = _storage.ref().child('user_profiles/${_user!.uid}');
      final uploadTask = await ref.putFile(file);
      final String photoURL = await uploadTask.ref.getDownloadURL();

      await _user!.updatePhotoURL(photoURL);
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } catch (e) {
      throw Exception("Error updating profile picture: $e");
    }
  }

  Future<void> updateDisplayName({required String displayName}) async {
    if (_user == null) return;

    try {
      await _user!.updateDisplayName(displayName);
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } catch (e) {
      throw Exception("Error updating display name: $e");
    }
  }

  Future<void> updateEmail({required String email}) async {
    if (_user == null) return;

    try {
      await _user!.verifyBeforeUpdateEmail(email);
      _user = FirebaseAuth.instance.currentUser;
      notifyListeners();
    } catch (e) {
      throw Exception("Error updating email: $e");
    }
  }
}
