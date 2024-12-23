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
    // Set the position to bottom-right
    double x = MediaQuery.of(context).size.width - 70; // FAB width (assuming it's 56px + margin)
    double y = MediaQuery.of(context).size.height - 70; // FAB height (assuming it's 56px + margin)

    position = Offset(x, y);
    notifyListeners();
  }
}
