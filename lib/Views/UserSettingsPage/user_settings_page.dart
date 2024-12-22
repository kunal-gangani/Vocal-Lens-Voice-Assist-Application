import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';

class UserSettingsPage extends StatelessWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Flexify.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new_outlined,
          ),
        ),
        title: const Text(
          "User Settings",
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Profile Settings Section
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
                    'https://t3.ftcdn.net/jpg/08/85/74/06/240_F_885740668_abO65GvCfjpbwKjsL3Zx37Pgxg2CCMi2.jpg',
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
                  'Tap to change profile picture',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                onTap: () {},
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            // Notifications Section
            Card(
              elevation: 5,
              color: Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: const Text(
                  'Notifications',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Enable or disable app notifications',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                trailing: Switch(
                  value: true,
                  onChanged: (bool value) {},
                  activeColor: Colors.blueGrey.shade900,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            // Dark Mode Section
            Card(
              elevation: 5,
              color: Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: const Text(
                  'Dark Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Enable or disable dark theme',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                trailing: Switch(
                  value: false,
                  onChanged: (bool value) {},
                  activeColor: Colors.blueGrey.shade900,
                ),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            // Language Settings Section
            Card(
              elevation: 5,
              color: Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: const Text(
                  'Language',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: const Text(
                  'Change app language',
                  style: TextStyle(
                    color: Colors.white70,
                  ),
                ),
                onTap: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
