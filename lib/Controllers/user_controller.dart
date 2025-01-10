import 'package:flutter/material.dart';
import 'package:vocal_lens/Helper/firebase_helper.dart';

class UserController extends ChangeNotifier {
  final AuthHelper _authHelper = AuthHelper();

  List<String> allUsers = [];
  List<String> filteredUsers = [];
  List<String> sentRequests = [];

  
  Future<void> fetchUsers() async {
    try {
      allUsers = await _authHelper.getAllUsers();
      filteredUsers = List.from(allUsers);
      notifyListeners();
    } catch (e) {
      throw Exception("Error fetching users: $e");
    }
  }


  Future<void> sendConnectionRequest(String userName) async {
    try {
      await _authHelper.sendConnectionRequest(userName);
      sentRequests.add(userName);
      notifyListeners();
    } catch (e) {
      throw Exception("Error sending connection request: $e");
    }
  }

 
  Future<bool> hasSentRequest(String userName) async {
    try {
      return await _authHelper.hasSentRequest(userName);
    } catch (e) {
      throw Exception("Error checking connection request status: $e");
    }
  }

  Future<List<Map<String, dynamic>>> getConnectionRequests() async {
    try {
      return await _authHelper.getConnectionRequests();
    } catch (e) {
      throw Exception("Error fetching connection requests: $e");
    }
  }

  
  void filterUsers(String query) {
    filteredUsers = allUsers
        .where((user) => user.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }
}
