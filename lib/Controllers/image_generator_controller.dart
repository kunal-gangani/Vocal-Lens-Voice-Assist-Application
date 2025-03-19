import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:vocal_lens/Helper/image_generator_helper.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ImageGeneratorController extends ChangeNotifier {
  final ImageGeneratorHelper _imageGenerator = ImageGeneratorHelper();

  Uint8List? generatedImage;
  bool isLoading = false;
  String? errorMessage;

  Future<void> generateImage(String prompt) async {
    try {
      isLoading = true;
      generatedImage = null;
      errorMessage = null;
      notifyListeners();

      Uint8List imageData = await _imageGenerator.generateImage(prompt);

      log("API Response: ${imageData.length} bytes");

      generatedImage = imageData;
    } catch (e) {
      errorMessage = e.toString();
      log("Error: $e");

      Fluttertoast.showToast(
        msg: "Image generation failed. Please try again!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );

      // ✅ Keep the image section empty
      generatedImage = null;
      errorMessage = null;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
