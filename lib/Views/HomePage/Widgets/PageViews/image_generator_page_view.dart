import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/image_generator_controller.dart';

Widget imageGeneratorPageView() {
  TextEditingController promptController = TextEditingController();

  return Consumer<ImageGeneratorController>(
    builder: (context, imageController, _) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 🔵 Input Field for User Prompt
              TextField(
                controller: promptController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Enter your image prompt...",
                  hintStyle: const TextStyle(
                    color: Colors.white54,
                  ),
                  filled: true,
                  fillColor: Colors.grey.shade800,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.clear,
                      color: Colors.white54,
                    ),
                    onPressed: () {
                      promptController.clear();
                    },
                  ),
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              // 🖼️ Image Display Area
              Expanded(
                child: Center(
                  child: imageController.isLoading
                      ? const SpinKitFadingCircle(
                          color: Colors.blue,
                          size: 50.0,
                        )
                      : imageController.generatedImage == null
                          ? Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (imageController.errorMessage != null)
                                  Text(
                                    imageController.errorMessage!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 16,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                if (imageController.errorMessage == null)
                                  const Text(
                                    "Enter a prompt and generate an image!",
                                    style: TextStyle(color: Colors.white70),
                                  ),
                              ],
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.memory(
                                imageController
                                    .generatedImage!, // ✅ Display raw binary image
                                fit: BoxFit.cover,
                                width: double.infinity,
                              ),
                            ),
                ),
              ),

              // 🔘 Generate Button
              ElevatedButton(
                onPressed: () {
                  if (promptController.text.isNotEmpty) {
                    imageController.generateImage(
                      promptController.text,
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  "Generate Image",
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
