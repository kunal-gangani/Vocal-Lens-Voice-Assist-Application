import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:vocal_lens/Helper/image_generator_helper.dart';

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
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}