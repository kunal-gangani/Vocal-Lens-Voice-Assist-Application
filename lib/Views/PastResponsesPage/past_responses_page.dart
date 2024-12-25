import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';
import 'package:vocal_lens/Views/HomePage/home_page.dart';

class PastResponsesPage extends StatelessWidget {
  const PastResponsesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
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
          "Past Responses",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: Colors.blueGrey.shade900,
        actions: [
          TextButton(
            onPressed: () {
              Flexify.goRemove(
                const HomePage(),
                animation: FlexifyRouteAnimations.blur,
                duration: Durations.medium1,
              );
            },
            child: const Text(
              "Search More",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<VoiceToTextController>(builder: (context, value, _) {
        return Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 16.0,
            vertical: 12.0,
          ),
          child: value.history.isEmpty
              ? const Center(
                  child: Text(
                    "No past responses yet.",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                )
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: value.history.length,
                        itemBuilder: (context, index) {
                          final query = value.history[index];

                          return Slidable(
                            key: ValueKey(index),
                            startActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              extentRatio: 0.25,
                              children: [
                                SlidableAction(
                                  onPressed: (context) {
                                    value.deleteHistory(index);
                                  },
                                  backgroundColor: Colors.red.shade700,
                                  foregroundColor: Colors.white,
                                  icon: Icons.delete,
                                  label: 'Delete',
                                ),
                              ],
                            ),
                            child: TimelineTile(
                              alignment: TimelineAlign.start,
                              isFirst: index == 0,
                              isLast: index == value.history.length - 1,
                              indicatorStyle: IndicatorStyle(
                                width: 20,
                                height: 20,
                                color: Colors.blueGrey.shade400,
                                padding: const EdgeInsets.all(8),
                                iconStyle: IconStyle(
                                  color: Colors.white,
                                  iconData: Icons.check_circle_outline,
                                ),
                              ),
                              beforeLineStyle: const LineStyle(
                                color: Colors.grey,
                                thickness: 4,
                              ),
                              afterLineStyle: const LineStyle(
                                color: Colors.grey,
                                thickness: 4,
                              ),
                              endChild: Card(
                                elevation: 12,
                                shadowColor: Colors.black54,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Container(
                                  padding: const EdgeInsets.all(18.0),
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey.shade800,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CircleAvatar(
                                            radius: 28,
                                            backgroundColor:
                                                Colors.blueGrey.shade600,
                                            child: const Icon(
                                              Icons.message,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const SizedBox(
                                            width: 15,
                                          ),
                                          Expanded(
                                            child: Text(
                                              query,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () {
                                              if (value.favoritesList
                                                  .contains(query)) {
                                                value
                                                    .removeFromFavorites(query);
                                              } else {
                                                value.addToFavorites(query);
                                              }
                                            },
                                            icon: Icon(
                                              value.favoritesList
                                                      .contains(query)
                                                  ? Icons.favorite
                                                  : Icons.favorite_border,
                                              color: value.favoritesList
                                                      .contains(query)
                                                  ? Colors.red
                                                  : Colors.red.shade300,
                                            ),
                                          )
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Text(
                                          "Date: ${DateTime.now().toString().split(' ')[0]}",
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
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
      }),
    );
  }
}
