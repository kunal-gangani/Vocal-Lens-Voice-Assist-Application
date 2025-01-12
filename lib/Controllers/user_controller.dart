import 'package:flutter/material.dart';
import 'package:vocal_lens/Helper/firebase_helper.dart';

class UserController extends ChangeNotifier {
  final AuthHelper _authHelper = AuthHelper();

  List<String> allUsers = [];
  List<String> filteredUsers = [];
  List<String> sentRequests = [];
  List<Map<String, dynamic>> receivedRequests = [];
  List<String> connections = [];

  /// Fetch all users
  Future<void> fetchUsers() async {
    try {
      allUsers = await _authHelper.getAllUsers();
      filteredUsers = List.from(allUsers);
      notifyListeners();
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }

  /// Send connection request to a user
  Future<void> sendConnectionRequest(String userName) async {
    try {
      await _authHelper.sendConnectionRequest(userName);
      sentRequests.add(userName);
      notifyListeners();
    } catch (e) {
      throw Exception("Error sending connection request: $e");
    }
  }

  /// Check if a connection request has been sent to a user
  Future<bool> hasSentRequest(String userName) async {
    try {
      return await _authHelper.hasSentRequest(userName);
    } catch (e) {
      throw Exception("Error checking connection request status: $e");
    }
  }

  /// Fetch received connection requests
  Future<void> fetchConnectionRequests() async {
    try {
      final requests = await _authHelper.getConnectionRequests();
      receivedRequests = requests;
      notifyListeners();
    } catch (e) {
      throw Exception("Error fetching connection requests: $e");
    }
  }

  /// Accept a connection request
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

  /// Decline a connection request
  Future<void> declineConnectionRequest(String userName) async {
    try {
      await _authHelper.rejectConnectionByUserName(userName);
      receivedRequests.removeWhere((request) => request['sender'] == userName);
      notifyListeners();
    } catch (e) {
      throw Exception("Error declining connection request: $e");
    }
  }

  /// Filter users based on a query
  void filterUsers(String query) {
    filteredUsers = allUsers
        .where((user) => user.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
