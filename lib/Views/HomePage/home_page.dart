import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';
import 'package:vocal_lens/Views/HomePage/Widgets/action_buttons.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "VocalLens",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: const FaIcon(
              FontAwesomeIcons.commentDots,
            ),
            onPressed:
                Provider.of<VoiceToTextController>(context).openChatSection,
            color: Colors.white,
          ),
        ],
      ),
      drawer: Consumer<VoiceToTextController>(builder: (context, value, _) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
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
                ),
                title: const Text(
                  "Past Responses",
                ),
                onTap: value.openPastResponses,
              ),
              ListTile(
                leading: const Icon(
                  Icons.star,
                ),
                title: const Text(
                  "Favorite Responses",
                ),
                onTap: value.openFavoriteResponses,
              ),
              ListTile(
                leading: const Icon(
                  Icons.settings,
                ),
                title: const Text("Settings"),
                onTap: () {},
              ),
            ],
          ),
        );
      }),
      body: Container(
        height: double.infinity,
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
        padding: const EdgeInsets.symmetric(
          horizontal: 20.0,
          vertical: 20.0,
        ),
        child: Consumer<VoiceToTextController>(builder: (context, value, _) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // Display the recognized text
                Card(
                  elevation: 10,
                  color: Colors.white.withOpacity(0.9),
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
                              color: Colors.black87,
                            ),
                            textAlign: TextAlign.center,
                          ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                // Action buttons in a Column
                Row(
                  children: [
                    actionButton(
                      icon: value.isListening ? Icons.mic_off : Icons.mic,
                      onPressed: value.isListening
                          ? value.stopListening
                          : value.startListening,
                      label: value.isListening ? "Stop" : "Speak",
                      buttonColor: Colors.teal,
                      textColor: Colors.white,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    actionButton(
                      icon: Icons.volume_up,
                      onPressed: value.speakText,
                      label: "Speak",
                      buttonColor: Colors.teal.shade700,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    actionButton(
                      icon: Icons.search,
                      onPressed: value.searchOnGoogle,
                      label: "Search",
                      buttonColor: Colors.teal.shade500,
                      textColor: Colors.white,
                    ),
                    const SizedBox(
                      width: 50,
                    ),
                    actionButton(
                      icon: Icons.clear,
                      onPressed: value.clearText,
                      label: "Clear",
                      buttonColor: Colors.redAccent,
                      textColor: Colors.white,
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                // Query Input Section
                Card(
                  elevation: 10,
                  color: Colors.white.withOpacity(0.9),
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
                            color: Colors.black87,
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
                                    ),
                                    onPressed: (value.isButtonEnabled == false)
                                        ? null
                                        : value.searchYourQuery,
                                  ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 275,
                  child: Card(
                    elevation: 10,
                    color: Colors.white.withOpacity(0.9),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                "Responses",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.expand,
                                  size: 20,
                                ),
                                onPressed: value.openResponsesInZoom,
                              ),
                            ],
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
                                  elevation: 10,
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
                                        Text(
                                          "Q. ${value.responses[index]['question']}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Ans:\n${value.responses[index]['answer']}",
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w400,
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
