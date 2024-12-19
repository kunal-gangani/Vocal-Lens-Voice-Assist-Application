import 'package:flutter/material.dart';

Widget actionButton({
  required IconData icon,
  required VoidCallback onPressed,
  required String label,
  required Color buttonColor,
  required Color textColor,
}) {
  return ElevatedButton.icon(
    onPressed: onPressed,
    icon: Icon(icon, color: textColor),
    label: Text(label, style: TextStyle(color: textColor)),
    style: ElevatedButton.styleFrom(
      minimumSize: const Size(160, 60),
      backgroundColor: buttonColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 10,
      padding: const EdgeInsets.symmetric(
        horizontal: 25,
      ),
    ),
  );
}
