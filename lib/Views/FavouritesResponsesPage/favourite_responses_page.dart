import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';

class FavouriteResponsesPage extends StatelessWidget {
  const FavouriteResponsesPage({super.key});

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
          "Favourite Responses",
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: 10,
          itemBuilder: (context, index) {
            return Card(
              elevation: 8,
              color: Colors.blueGrey.shade800,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                leading: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 40,
                ),
                title: Text(
                  "Favourite Response Title $index",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 4),
                    const Text(
                      "This is a short description or excerpt from the response.",
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Date: ${DateTime.now().toString().split(' ')[0]}",
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    // Implement remove from favourites functionality
                  },
                ),
                onTap: () {
                  // Implement tap functionality (e.g., open a detailed view)
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
