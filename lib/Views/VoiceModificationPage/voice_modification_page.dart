import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';

class VoiceModificationPage extends StatelessWidget {
  const VoiceModificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final voiceController = Provider.of<VoiceToTextController>(context);

    final List<String> voiceModels = [
      "en-us",
      "en-gb",
      "en-in",
      "robotic",
    ];

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.blueGrey.shade900,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () => Flexify.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        title: const Text(
          "Modify Voice Settings",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            DropdownButton<String>(
              value: voiceController.voice,
              onChanged: (newValue) {
                if (newValue != null) {
                  voiceController.setVoice(newValue);
                }
              },
              items: voiceModels.map<DropdownMenuItem<String>>((String model) {
                return DropdownMenuItem<String>(
                  value: model,
                  child: Text(model),
                );
              }).toList(),
            ),

            Row(
              children: [
                const Text(
                  "Pitch:",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Slider(
                  activeColor: Colors.blueGrey,
                  value: voiceController.pitch,
                  min: 0.5,
                  max: 2.0,
                  divisions: 10,
                  onChanged: (value) {
                    voiceController.setPitch(value);
                  },
                ),
                Text(
                  voiceController.pitch.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            // Speech Rate Slider
            Row(
              children: [
                const Text(
                  "Speech Rate:",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                Slider(
                  value: voiceController.speechRate,
                  min: 0.1,
                  max: 1.0,
                  divisions: 9,
                  onChanged: (value) {
                    voiceController.setSpeechRate(
                        value); // Update speech rate in the controller
                  },
                ),
                Text(voiceController.speechRate.toStringAsFixed(1)),
              ],
            ),

            // Button to preview the selected settings
            ElevatedButton(
              onPressed: () {
                // Preview the voice based on the settings
                voiceController.readOrPromptResponse();
              },
              child: const Text("Preview Voice"),
            ),
          ],
        ),
      ),
    );
  }
}
