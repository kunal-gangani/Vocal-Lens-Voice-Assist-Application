import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vocal_lens/Views/UserChat/user_chat.dart';

class ChatSectionPage extends StatelessWidget {
  const ChatSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Flexify.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
          ),
        ),
        foregroundColor: Colors.white,
        title: const Text(
          "Chat Section",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // User List Section
            Card(
              elevation: 5,
              color: Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-psd/contact-icon-illustration-isolated_23-2151903337.jpg?ga=GA1.1.132821578.1730041723&semt=ais_hybrid',
                  ),
                ),
                title: const Text(
                  'John Doe',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Hey, how are you?',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                trailing: const Icon(
                  FontAwesomeIcons.rocketchat,
                  color: Colors.white,
                ),
                onTap: () {
                  Flexify.go(
                    const UserChatPage(),
                    animation: FlexifyRouteAnimations.blur,
                    animationDuration: Durations.medium1,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 5,
              color: Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-psd/contact-icon-illustration-isolated_23-2151903337.jpg?ga=GA1.1.132821578.1730041723&semt=ais_hybrid',
                  ),
                ),
                title: const Text(
                  'Jane Smith',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Let\'s meet up tomorrow!',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                trailing: const Icon(
                  FontAwesomeIcons.rocketchat,
                  color: Colors.white,
                ),
                onTap: () {
                  Flexify.go(
                    const UserChatPage(),
                    animation: FlexifyRouteAnimations.blur,
                    animationDuration: Durations.medium1,
                  );
                },
              ),
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 5,
              color: Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(
                    'https://img.freepik.com/free-psd/contact-icon-illustration-isolated_23-2151903337.jpg?ga=GA1.1.132821578.1730041723&semt=ais_hybrid',
                  ),
                ),
                title: const Text(
                  'Alex Johnson',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Got your message!',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                trailing: const Icon(
                  FontAwesomeIcons.rocketchat,
                  color: Colors.white,
                ),
                onTap: () {
                  Flexify.go(
                    const UserChatPage(),
                    animation: FlexifyRouteAnimations.blur,
                    animationDuration: Durations.medium1,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
