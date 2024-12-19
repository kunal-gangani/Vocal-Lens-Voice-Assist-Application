import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vocal_lens/Views/UserChat/user_chat.dart';

class ChatSectionPage extends StatelessWidget {
  const ChatSectionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.teal.shade300,
              Colors.teal.shade900,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const UserList(),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    // Sample data representing users
    final List<Map<String, String>> users = [
      {
        "name": "John Doe",
        "profilePictureUrl":
            "https://img.freepik.com/free-psd/contact-icon-illustration-isolated_23-2151903337.jpg?ga=GA1.1.132821578.1730041723&semt=ais_hybrid",
        "lastMessage": "Hey, how are you?",
      },
      {
        "name": "Jane Smith",
        "profilePictureUrl":
            "https://img.freepik.com/free-psd/contact-icon-illustration-isolated_23-2151903337.jpg?ga=GA1.1.132821578.1730041723&semt=ais_hybrid",
        "lastMessage": "Let's meet up tomorrow!",
      },
      {
        "name": "Alex Johnson",
        "profilePictureUrl":
            "https://img.freepik.com/free-psd/contact-icon-illustration-isolated_23-2151903337.jpg?ga=GA1.1.132821578.1730041723&semt=ais_hybrid",
        "lastMessage": "Got your message!",
      },
    ];

    return ListView.separated(
      separatorBuilder: (context, index) {
        return const Divider();
      },
      itemCount: users.length,
      itemBuilder: (context, index) {
        final user = users[index];
        return ListTile(
          onTap: () {
            Flexify.go(
              const UserChatPage(),
              animation: FlexifyRouteAnimations.blur,
              animationDuration: Durations.medium1,
            );
          },
          leading: CircleAvatar(
            backgroundImage: NetworkImage(user['profilePictureUrl']!),
          ),
          title: Text(
            user['name']!,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          subtitle: Text(
            user['lastMessage']!,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          trailing: const Icon(
            FontAwesomeIcons.rocketchat,
            color: Colors.white,
          ),
        );
      },
    );
  }
}
