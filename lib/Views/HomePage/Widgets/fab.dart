import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';

Widget floatingButton() {
  return Consumer<VoiceToTextController>(
    builder: (context, value, _) {
      return GestureDetector(
        onTap: value.isListening ? value.stopListening : value.startListening,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: value.isListening
                ? [
                    BoxShadow(
                      color: Colors.blueGrey.shade600,
                      blurRadius: 15,
                      spreadRadius: 5,
                    ),
                  ]
                : [],
          ),
          child: FloatingActionButton(
            onPressed: null,
            backgroundColor: Colors.blueGrey.shade600,
            child: Icon(
              value.isListening ? Icons.mic_off : Icons.mic,
              color: Colors.white,
            ),
          ),
        ),
      );
    },
  );
}
