import 'package:flutter/material.dart';

class PositionController extends ChangeNotifier {
  Offset position = const Offset(0, 0);

  // Update position with new coordinates
  void updatePosition(Offset newPosition) {
    position = newPosition;
    notifyListeners();
  }

  // Reset the FAB position to bottom-right
  void resetPosition(BuildContext context) {
    double x = MediaQuery.of(context).size.width - 70;
    double y = MediaQuery.of(context).size.height - 70;

    position = Offset(x, y);
    notifyListeners();
  }
}
