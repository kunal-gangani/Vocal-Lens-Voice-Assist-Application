import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vocal_lens/Helper/auth_helper.dart';

class UserController extends ChangeNotifier {
  final AuthHelper _authHelper = AuthHelper();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  List<String> allUsers = [];
  List<String> filteredUsers = [];
  List<String> sentRequests = [];
  List<Map<String, dynamic>> receivedRequests = [];
  List<String> connections = [];

  UserController() {
    listenToUsers();
  }

  void listenToUsers() {
    _firestore.collection('users').snapshots().listen((snapshot) {
      allUsers = snapshot.docs.map((doc) {
        final data = doc.data();
        return data.containsKey('username')
            ? data['username'] as String
            : "Unnamed";
      }).toList();

      filteredUsers = List.from(allUsers);
      log("Updated users: $allUsers");
      notifyListeners();
    });
  }

  void filterUsers(String query) {
    filteredUsers = allUsers
        .where((user) => user.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  Future<void> fetchUsers() async {
    try {
      allUsers = await _authHelper.getAllUsers();
      filteredUsers = List.from(allUsers);
      notifyListeners();
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }

  Future<void> sendConnectionRequest(String recipientId) async {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      log("❌ Error: User not authenticated.");
      return;
    }

    final connectionRequest = {
      'from': currentUser.uid,
      'to': recipientId,
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    };

    log("🟢 Sending request: $connectionRequest");

    try {
      await FirebaseFirestore.instance
          .collection('connection_requests')
          .add(connectionRequest);
      log("✅ Request sent!");
    } catch (e) {
      log("❌ Firestore Error: $e");
    }
  }

  Future<bool> hasSentRequest(String userName) async {
    try {
      return await _authHelper.hasSentRequest(userName);
    } catch (e) {
      throw Exception("Error checking connection request status: $e");
    }
  }

  Future<void> fetchConnectionRequests() async {
    try {
      final requests = await _authHelper.getConnectionRequests();
      receivedRequests = requests;
      notifyListeners();
    } catch (e) {
      throw Exception("Error fetching connection requests: $e");
    }
  }

  Future<void> acceptConnectionRequest(String userName) async {
    try {
      await _authHelper.acceptConnectionByUserName(userName);
      connections.add(userName);
      receivedRequests.removeWhere((request) => request['sender'] == userName);
      notifyListeners();
    } catch (e) {
      throw Exception("Error accepting connection request: $e");
    }
  }

  Future<void> declineConnectionRequest(String userName) async {
    try {
      await _authHelper.rejectConnectionByUserName(userName);
      receivedRequests.removeWhere((request) => request['sender'] == userName);
      notifyListeners();
    } catch (e) {
      throw Exception("Error declining connection request: $e");
    }
  }
}
