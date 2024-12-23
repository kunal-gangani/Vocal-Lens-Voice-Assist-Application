import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_glow/flutter_glow.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';
import 'package:vocal_lens/Controllers/position_controller.dart';

Widget floatingButton() {
  return Consumer2<VoiceToTextController, PositionController>(
    builder: (context, voiceToTextController, positionController, _) {
      return Stack(
        children: [
          Positioned(
            left: positionController.position.dx,
            top: positionController.position.dy,
            child: GestureDetector(
              onPanUpdate: (details) {
                // Allow FAB to drag
                positionController.updatePosition(details.localPosition);
              },
              child: Draggable(
                feedback: GlowContainer(
                  shape: BoxShape.circle,
                  glowColor: voiceToTextController.isListening
                      ? Colors.blue
                      : Colors.transparent,
                  blurRadius: voiceToTextController.isListening ? 30 : 0,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey.shade600,
                      boxShadow: voiceToTextController.isListening
                          ? [
                              const BoxShadow(
                                color: Colors.blue,
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ]
                          : [],
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        // Start/Stop voice recording when pressed
                        voiceToTextController.toggleListening();
                      },
                      backgroundColor: Colors.blueGrey.shade600,
                      child: Icon(
                        voiceToTextController.isListening
                            ? Icons.mic_off
                            : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                childWhenDragging: Container(),
                onDragEnd: (details) {
                  positionController.updatePosition(details.offset);
                },
                child: GlowContainer(
                  shape: BoxShape.circle,
                  glowColor: voiceToTextController.isListening
                      ? Colors.blue
                      : Colors.transparent,
                  blurRadius: voiceToTextController.isListening ? 30 : 0,
                  color: Colors.transparent,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blueGrey.shade600,
                      boxShadow: voiceToTextController.isListening
                          ? [
                              const BoxShadow(
                                color: Colors.blue,
                                blurRadius: 15,
                                spreadRadius: 5,
                              ),
                            ]
                          : [],
                    ),
                    child: FloatingActionButton(
                      onPressed: () {
                        // Start/Stop voice recording when pressed
                        voiceToTextController.toggleListening();
                      },
                      backgroundColor: Colors.blueGrey.shade600,
                      child: Icon(
                        voiceToTextController.isListening
                            ? Icons.mic_off
                            : Icons.mic,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    },
  );
}
