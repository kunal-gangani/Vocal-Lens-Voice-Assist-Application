import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/chat_with_ai_controller.dart';

Widget chatWithAIPage() {
  return Consumer<ChatWithAiController>(
    builder: (context, chatController, _) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text(
            "Chat with Gemini-AI",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.blueGrey.shade900,
        ),
        body: Container(
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueGrey.shade900,
                Colors.black,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: chatController.getMessages.length,
                  itemBuilder: (context, index) {
                    final message = chatController.getMessages[index];
                    bool isUserMessage = message.containsKey('user');
                    return Align(
                      alignment: isUserMessage
                          ? Alignment.centerRight
                          : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 5.0),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        decoration: BoxDecoration(
                          color: isUserMessage
                              ? Colors.blueAccent
                              : Colors.grey.shade800,
                          borderRadius: BorderRadius.only(
                            topLeft: const Radius.circular(15.0),
                            topRight: const Radius.circular(15.0),
                            bottomLeft: isUserMessage
                                ? const Radius.circular(15.0)
                                : Radius.zero,
                            bottomRight: isUserMessage
                                ? Radius.zero
                                : const Radius.circular(15.0),
                          ),
                        ),
                        child: Text(
                          isUserMessage
                              ? message['user']!
                              : message['ai'] ?? '...',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                ),
              ),

              // Input Bar
              Card(
                elevation: 5,
                color: Colors.blueGrey.shade800,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: chatController.messageController,
                          decoration: const InputDecoration(
                            hintText: "Type your message...",
                            hintStyle: TextStyle(color: Colors.white70),
                            border: InputBorder.none,
                          ),
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          chatController.searchQuery();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
