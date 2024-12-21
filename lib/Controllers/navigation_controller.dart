import 'package:flutter/material.dart';

class NavigationController extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void changeItem(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void changePageView({
    required int index,
    required int val,
  }) {
    index = val;
    notifyListeners();
  }
}
