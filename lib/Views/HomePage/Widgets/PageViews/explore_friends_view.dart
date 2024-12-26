import 'package:flutter/material.dart';

Widget exploreFriendsPageView() {
  final TextEditingController searchController = TextEditingController();
  final List<String> allUsers = [
    "John Doe",
    "Jane Smith",
    "Michael Johnson",
    "Emily Davis",
    "David Wilson",
    "Sophia Brown",
    "Chris Taylor",
    "Olivia Martin",
    "Daniel Lee",
    "Emma White",
  ];

  List<String> filteredUsers = List.from(allUsers);
  List<String> sentRequests = [];

  void filterUsers(String query) {
    filteredUsers = allUsers
        .where(
            (user) => user.toLowerCase().contains(query.toLowerCase().trim()))
        .toList();
  }

  return StatefulBuilder(
    builder: (context, setState) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Card(
              elevation: 5,
              color: Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey.shade900,
                    hintText: "Search for users...",
                    hintStyle: const TextStyle(
                      color: Colors.white54,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(
                      Icons.search,
                      color: Colors.cyan,
                    ),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, color: Colors.red),
                      onPressed: () {
                        searchController.clear();
                        setState(() {
                          filterUsers('');
                        });
                      },
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      filterUsers(value);
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // User List
            Expanded(
              child: filteredUsers.isEmpty
                  ? const Center(
                      child: Text(
                        "No users found",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: filteredUsers.length,
                      itemBuilder: (context, index) {
                        String user = filteredUsers[index];
                        bool requestSent = sentRequests.contains(user);

                        return Card(
                          elevation: 5,
                          color: Colors.blueGrey.shade800,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.cyan,
                              child: Text(
                                user[0],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(
                              user,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            trailing: requestSent
                                ? const Icon(
                                    Icons.hourglass_empty,
                                    color: Colors.grey,
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        sentRequests.add(user);
                                      });
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.cyan,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    child: const Text(
                                      "Connect",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      );
    },
  );
}
