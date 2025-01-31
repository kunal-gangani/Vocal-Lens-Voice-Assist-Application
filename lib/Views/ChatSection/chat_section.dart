import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/user_controller.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';

class ChatSectionPage extends StatelessWidget {
  const ChatSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Provider.of<UserController>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Flexify.back(),
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        foregroundColor: Colors.white,
        title: Text(
          "Chat Section",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder(
          future: userController.fetchUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.blueGrey,
                ),
              );
            } else if (snapshot.hasData &&
                userController.filteredUsers.isEmpty) {
              return Center(
                child: Text(
                  "No connections yet! Add some connections.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                  ),
                ),
              );
            }
            return ListView.builder(
              itemCount: userController.filteredUsers.length,
              itemBuilder: (context, index) {
                final userName = userController.filteredUsers[index];
                return Card(
                  elevation: 5,
                  color: Colors.blueGrey.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: CircleAvatar(
                      radius: 30.r,
                      backgroundImage: const NetworkImage(
                        'https://img.freepik.com/free-psd/contact-icon-illustration-isolated_23-2151903337.jpg',
                      ),
                    ),
                    title: Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Tap to chat',
                      style: TextStyle(
                        color: Colors.white70,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chat,
                      color: Colors.white,
                    ),
                    onTap: () {
                      Provider.of<VoiceToTextController>(context)
                          .openChatSection();
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
