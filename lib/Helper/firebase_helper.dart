import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Sign in with Email & Password
  Future<User?> signInWithEmail(String email, String password) async {
    try {
      final UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } catch (e) {
      throw Exception("Error signing in with email: $e");
    }
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception("Google sign-in aborted");
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);

      await createUserDocument(userCredential.user!);
      return userCredential.user;
    } catch (e) {
      throw Exception("Google sign-in failed: $e");
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }

  // Get current logged-in user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Create user document in Firestore
  Future<void> createUserDocument(User user) async {
    try {
      final userRef = _firestore.collection('users').doc(user.uid);
      final docSnapshot = await userRef.get();

      if (!docSnapshot.exists) {
        await userRef.set({
          'username': user.displayName ?? 'Unnamed',
          'email': user.email,
          'uid': user.uid,
          'profile_picture': user.photoURL ?? '',
        });
      }
    } catch (e) {
      throw Exception("Error creating user document: $e");
    }
  }

  // Get all registered users (except current user)
  Future<List<String>> getAllUsers() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user is logged in.");
      }

      final usersSnapshot = await _firestore.collection('users').get();
      List<String> users = [];
      for (var doc in usersSnapshot.docs) {
        if (doc.id != currentUser.uid) {
          users.add(doc['username']);
        }
      }
      return users;
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }

  // Send a connection request
  Future<void> sendConnectionRequest(String userName) async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser == null) {
        throw Exception("No user is logged in.");
      }

      await _firestore.collection('connection_requests').add({
        'sender': currentUser.uid,
        'receiver': userName,
        'status': 'pending',
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception("Error sending connection request: $e");
    }
  }

  // Check if connection request has been sent
  Future<bool> hasSentRequest(String userName) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

    try {
      final querySnapshot = await _firestore
          .collection('connection_requests')
          .where('sender', isEqualTo: currentUser.uid)
          .where('receiver', isEqualTo: userName)
          .where('status', isEqualTo: 'pending')
          .get();

      return querySnapshot.docs.isNotEmpty;
    } catch (e) {
      throw Exception("Error checking request status: $e");
    }
  }

  // Get received connection requests
  Future<List<Map<String, dynamic>>> getConnectionRequests() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

    try {
      final querySnapshot = await _firestore
          .collection('connection_requests')
          .where('receiver', isEqualTo: currentUser.uid)
          .get();

      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      throw Exception("Error fetching connection requests: $e");
    }
  }

  // Accept a connection request
  Future<void> acceptConnectionRequest(String requestId) async {
    try {
      final requestRef =
          _firestore.collection('connection_requests').doc(requestId);
      await requestRef.update({
        'status': 'accepted',
      });
    } catch (e) {
      throw Exception("Error accepting connection request: $e");
    }
  }

  // Reject a connection request
  Future<void> rejectConnectionRequest(String requestId) async {
    try {
      final requestRef =
          _firestore.collection('connection_requests').doc(requestId);
      await requestRef.update({
        'status': 'rejected',
      });
    } catch (e) {
      throw Exception("Error rejecting connection request: $e");
    }
  }

  // Get accepted connections
  Future<List<String>> getAcceptedConnections() async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

    try {
      final connectionsQuery = await _firestore
          .collection('connections')
          .doc(currentUser.uid)
          .collection('accepted')
          .get();

      return connectionsQuery.docs
          .map((doc) => doc.data()['username'] as String)
          .toList();
    } catch (e) {
      throw Exception("Error fetching accepted connections: $e");
    }
  }

  // Accept connection by username
  Future<void> acceptConnectionByUserName(String userName) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

    try {
      final querySnapshot = await _firestore
          .collection('connection_requests')
          .where('receiver', isEqualTo: currentUser.uid)
          .where('sender', isEqualTo: userName)
          .where('status', isEqualTo: 'pending')
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No pending request found from $userName.");
      }

      final requestDoc = querySnapshot.docs.first;

      await requestDoc.reference.update({
        'status': 'accepted',
      });

      await _firestore.collection('connections').doc(currentUser.uid).set({
        'accepted': FieldValue.arrayUnion([userName]),
      }, SetOptions(merge: true));

      final senderSnapshot = await _firestore
          .collection('users')
          .where('username', isEqualTo: userName)
          .get();

      if (senderSnapshot.docs.isNotEmpty) {
        final senderId = senderSnapshot.docs.first.id;
        await _firestore.collection('connections').doc(senderId).set({
          'accepted': FieldValue.arrayUnion([currentUser.displayName]),
        }, SetOptions(merge: true));
      }
    } catch (e) {
      throw Exception("Error accepting connection from $userName: $e");
    }
  }

  // Remove a connection
  Future<void> removeConnection(String userName) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

    try {
      await _firestore.collection('connections').doc(currentUser.uid).set({
        'accepted': FieldValue.arrayRemove([userName]),
      }, SetOptions(merge: true));
    } catch (e) {
      throw Exception("Error removing connection with $userName: $e");
    }
  }

  // Reject connection request by username
  Future<void> rejectConnectionByUserName(String userName) async {
    final currentUser = _auth.currentUser;
    if (currentUser == null) {
      throw Exception("No user is logged in.");
    }

    try {
      final querySnapshot = await _firestore
          .collection('connection_requests')
          .where('receiver', isEqualTo: currentUser.uid)
          .where('sender', isEqualTo: userName)
          .where('status', isEqualTo: 'pending')
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception("No pending request found from $userName.");
      }

      final requestDoc = querySnapshot.docs.first;
      await requestDoc.reference.update({
        'status': 'rejected',
      });
    } catch (e) {
      throw Exception("Error rejecting connection from $userName: $e");
    }
  }
}
