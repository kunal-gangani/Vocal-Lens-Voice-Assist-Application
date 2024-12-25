import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';

class FavouriteResponsesPage extends StatelessWidget {
  const FavouriteResponsesPage({super.key});

  @override
  Widget build(BuildContext context) {
    VoiceToTextController voiceToTextController =
        Provider.of<VoiceToTextController>(context);

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Flexify.back();
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            size: 24,
          ),
        ),
        foregroundColor: Colors.white,
        title: const Text(
          "Favourite Responses",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.blueGrey.shade900,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: voiceToTextController.favoritesList.isEmpty
            ? const Center(
                child: Text(
                  "No favorites yet!",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              )
            : ListView.builder(
                itemCount: voiceToTextController.favoritesList.length,
                itemBuilder: (context, index) {
                  String favoriteResponse =
                      voiceToTextController.favoritesList[index];

                  return Slidable(
                    key: ValueKey(index),
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          onPressed: (context) {
                            voiceToTextController.deleteHistory(index);
                          },
                          backgroundColor: Colors.red.shade700,
                          foregroundColor: Colors.white,
                          icon: Icons.delete,
                          label: 'Delete',
                        ),
                      ],
                    ),
                    child: Card(
                      elevation: 8,
                      color: Colors.blueGrey.shade800,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      shadowColor: Colors.black.withOpacity(0.5),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16.0),
                        leading: const Icon(
                          Icons.favorite,
                          color: Colors.redAccent,
                          size: 40,
                        ),
                        title: Text(
                          "Favorite Response #${index + 1}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              favoriteResponse,
                              style: const TextStyle(
                                color: Colors.white70,
                              ),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              "Date: ${DateTime.now().toString().split(' ')[0]}",
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            voiceToTextController
                                .removeFromFavorites(favoriteResponse);
                          },
                        ),
                        onTap: () {},
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
