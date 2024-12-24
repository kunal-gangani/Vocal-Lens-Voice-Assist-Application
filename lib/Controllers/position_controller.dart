import 'package:flutter/material.dart';

class PositionController extends ChangeNotifier {
  Offset position = const Offset(0, 0);

  /// Updates the position of the FloatingActionButton
  /// Ensures the position remains within screen bounds
  void updatePosition(Offset newPosition, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    // Clamp the position to prevent it from going out of bounds
    double x =
        newPosition.dx.clamp(0.0, screenWidth - 70); // Adjust for FAB size
    double y = newPosition.dy.clamp(0.0, screenHeight - 70);

    position = Offset(x, y);
    notifyListeners();
  }

  /// Resets the position of the FloatingActionButton to the bottom-right corner
  void resetPosition(BuildContext context) {
    double fabSize = 56.0; // Default FAB size
    double padding = 16.0; // Padding from screen edges

    double x = MediaQuery.of(context).size.width - fabSize - padding;
    double y = MediaQuery.of(context).size.height - fabSize - padding;

    position = Offset(x, y);
    notifyListeners();
  }

  /// Optionally initialize position at bottom-right corner
  /// Call this method during app initialization
  void initializePosition(BuildContext context) {
    if (position == const Offset(0, 0)) {
      resetPosition(context);
    }
  }
}
