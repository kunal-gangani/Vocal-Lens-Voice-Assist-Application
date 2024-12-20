import 'package:flexify/flexify.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/navigation_controller.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';
import 'package:vocal_lens/Views/DetailedResponsePage/detailed_response_pages.dart';
import 'package:vocal_lens/Views/HomePage/Widgets/navigation_destination.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      floatingActionButton: Consumer<VoiceToTextController>(
        builder: (context, value, _) {
          return GestureDetector(
            onTap:
                value.isListening ? value.stopListening : value.startListening,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: value.isListening
                    ? [
                        BoxShadow(
                          color: Colors.greenAccent.withOpacity(0.6),
                          blurRadius: 15,
                          spreadRadius: 5,
                        ),
                      ]
                    : [],
              ),
              child: FloatingActionButton(
                onPressed: null,
                backgroundColor: Colors.greenAccent,
                child: Icon(
                  value.isListening ? Icons.mic_off : Icons.mic,
                  color: Colors.white,
                ),
              ),
            ),
          );
        },
      ),
      bottomNavigationBar:
          Consumer<NavigationController>(builder: (context, value, _) {
        return NavigationBar(
          selectedIndex: value.selectedIndex,
          onDestinationSelected: value.changeItem,
          destinations: [
            navigationDestination(
              label: "Home",
              icon: const Icon(
                CupertinoIcons.square_favorites,
                color: Colors.blueAccent,
              ),
            ),
            navigationDestination(
              label: "Youtube",
              icon: const FaIcon(
                FontAwesomeIcons.youtube,
                color: Colors.red,
              ),
            ),
            navigationDestination(
              label: "AI Chat",
              icon: const Icon(
                Icons.memory,
                color: Colors.orange,
              ),
            ),
          ],
          backgroundColor: Colors.grey.shade800,
        );
      }),
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: const Text(
          "VocalLens",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.commentDots),
            onPressed:
                Provider.of<VoiceToTextController>(context).openChatSection,
            color: Colors.white,
          ),
        ],
      ),
      drawer: Consumer<VoiceToTextController>(builder: (context, value, _) {
        return Drawer(
          backgroundColor: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blueGrey.shade900,
                ),
                child: const Center(
                  child: Text(
                    "VocalLens Menu",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const Icon(
                  Icons.history,
                  color: Colors.orange,
                ),
                title: const Text(
                  "Past Responses",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: value.openPastResponses,
              ),
              ListTile(
                leading: const Icon(
                  Icons.star,
                  color: Colors.purple,
                ),
                title: const Text(
                  "Favorite Responses",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: value.openFavoriteResponses,
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                  color: Colors.green,
                ),
                title: const Text(
                  "Settings",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onTap: () {},
              ),
            ],
          ),
        );
      }),
      body: Container(
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
        child: Consumer<VoiceToTextController>(builder: (context, value, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  elevation: 5,
                  color: Colors.blueGrey.shade800,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: value.isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Text(
                            value.text,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 200,
                  child: Card(
                    elevation: 5,
                    color: Colors.blueGrey.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const Text(
                            "Enter your query:",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: value.searchFieldController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    hintText: "Type your query here",
                                    hintStyle: const TextStyle(
                                      color: Colors.white70,
                                    ),
                                  ),
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              (value.isLoading)
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : IconButton.filled(
                                      icon: const Icon(
                                        FontAwesomeIcons.paperPlane,
                                        color: Colors.white,
                                      ),
                                      onPressed:
                                          (value.isButtonEnabled == false)
                                              ? null
                                              : value.searchYourQuery,
                                    ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 275,
                  child: Card(
                    elevation: 5,
                    color: Colors.blueGrey.shade800,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Responses",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Flexible(
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: value.responses.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  elevation: 5,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Q. ${value.responses[index]['question']}",
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.cyan,
                                              ),
                                            ),
                                            IconButton(
                                              icon: const Icon(
                                                FontAwesomeIcons.expand,
                                                size: 20,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                Flexify.go(
                                                  DetailedResponsePages(
                                                    question:
                                                        value.responses[index]
                                                            ['question'],
                                                    answer:
                                                        value.responses[index]
                                                            ['answer'],
                                                  ),
                                                  animation:
                                                      FlexifyRouteAnimations
                                                          .blur,
                                                  animationDuration:
                                                      Durations.medium1,
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 8,
                                        ),
                                        Text(
                                          "Ans:\n${value.responses[index]['answer']}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
