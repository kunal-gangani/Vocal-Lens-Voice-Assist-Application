import 'package:flexify/flexify.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vocal_lens/Controllers/voice_to_text.dart';
import 'package:vocal_lens/Views/DetailedResponsePage/detailed_response_pages.dart';

Widget homePageView() {
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
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.center,
                      ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Card(
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
                    Text(
                      "Enter your Query:",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: value.searchFieldController,
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey.shade900,
                              hintText: "Type your query here",
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
                                icon: const Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                                onPressed: value.searchFieldController.clear,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        ElevatedButton(
                          onPressed: value.isButtonEnabled
                              ? value.searchYourQuery
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.cyan,
                            disabledBackgroundColor: Colors.grey,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          child: const Text(
                            "Search",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            // Responses Section
            SizedBox(
              height: 350.h,
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
                      Row(
                        children: [
                          Text(
                            "Response",
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 68.w,
                          ),
                          IconButton(
                            onPressed: () {
                              if (value.responses.isNotEmpty) {
                                value.readOrPromptResponse();
                              } else {
                                value.readOrPromptResponse();
                              }
                            },
                            icon: const Icon(
                              Icons.volume_up,
                              color: Colors.white,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              if (value.isSpeaking) {
                                value.stopSpeaking();
                              } else {
                                value.resumeSpeaking();
                              }
                            },
                            icon: Icon(
                              value.isSpeaking ? Icons.stop : Icons.play_arrow,
                              color: Colors.white,
                            ),
                          ),
                          Visibility(
                            visible: value.responses.isNotEmpty &&
                                value.responses[0]['answer'] != null &&
                                value.responses[0]['answer'].isNotEmpty,
                            child: IconButton(
                              onPressed: () {
                                Flexify.go(
                                  DetailedResponsePages(
                                    question: value.responses[0]['question'],
                                    answer: value.responses[0]['answer'],
                                  ),
                                  animation: FlexifyRouteAnimations.blur,
                                  animationDuration: Durations.medium1,
                                );
                              },
                              icon: const Icon(
                                Icons.open_in_full,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: value.responses.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 5,
                              margin: const EdgeInsets.symmetric(
                                vertical: 5,
                              ),
                              color: Colors.grey.shade900,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Que. ${value.responses[index]['question']}",
                                      style: TextStyle(
                                        fontSize: 16.h,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.cyan,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8.h,
                                    ),
                                    Text(
                                      "Ans:\n${value.responses[index]['answer']}",
                                      style: TextStyle(
                                        fontSize: 16.sp,
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
  );
}
