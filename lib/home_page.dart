import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:voice_assistant/openai_service.dart';
import 'package:voice_assistant/openai_service.dart';
import 'package:voice_assistant/openai_service.dart';
import 'package:voice_assistant/openai_service.dart';
import 'package:voice_assistant/openai_service.dart';
import 'package:voice_assistant/openai_service.dart';

import 'feature_box.dart';
import 'palette.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final speechToText = SpeechToText();
  final OpenAIService openAIService = OpenAIService();

  bool isInitialized = false;
  String lastWords = '';

  @override
  void initState() {
    super.initState();
    initSpeechToText();
    // speechToText.statusListener!((status) {
    //   log(status.toString());
    // } as String);
    // speechToText.errorListener!((error) {
    //   log(error.toString());
    // } as SpeechRecognitionError);
  }

  Future<void> initSpeechToText() async {
    isInitialized = await speechToText.initialize();
    setState(() {});
  }

  Future<void> startListening() async {
    if (isInitialized) {
      await speechToText.listen(
        onResult: onSpeechResult,
        onDevice: true,
      );
    } else {
      await initSpeechToText();
    }
    setState(() {});
  }

  Future<void> stopListening() async {
    await speechToText.stop();
    setState(() {});
  }

  void onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      lastWords = result.recognizedWords;
      print(result.alternates.toString());
    });
  }

  @override
  void dispose() {
    speechToText.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Assistant"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Center(
                  child: Container(
                    height: 120,
                    width: 120,
                    margin: const EdgeInsets.only(top: 4),
                    decoration: const BoxDecoration(
                      color: Palette.assistantCircleColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 123,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: AssetImage("assets/images/virtualAssistant.png"),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 20,
              ),
              margin: const EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
                border: Border.all(color: Palette.borderColor),
                borderRadius: BorderRadius.circular(20).copyWith(
                  topLeft: const Radius.circular(0),
                ),
              ),
              child: const Text(
                'Good Morning, What task can I do for you?',
                style: TextStyle(
                  color: Palette.mainFontColor,
                  fontSize: 25,
                  fontFamily: 'Cera-Pro',
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(
                top: 18,
              ),
              child: Text(
                'Here are a few features',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Palette.mainFontColor,
                ),
              ),
            ),
            const FeatureBox(
              headerText: 'ChatGPT',
              descriptionText:
                  'A smarter way to get organized and informed with ChatGPT',
              color: Palette.firstSuggestionBoxColor,
            ),
            const FeatureBox(
              headerText: 'ChatGPT',
              descriptionText:
                  'A smarter way to get organized and informed with ChatGPT',
              color: Palette.secondSuggestionBoxColor,
            ),
            const FeatureBox(
              headerText: 'Smart Voice Assistant',
              descriptionText:
                  'Get the best of both world with a voice assistant powered by Dall-E and ChatGPT',
              color: Palette.thirdSuggestionBoxColor,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Palette.firstSuggestionBoxColor,
        onPressed: () async {
          if (await speechToText.hasPermission && speechToText.isNotListening) {
            await startListening();
          } else if (speechToText.isListening) {
            final speech = await openAIService.isArtPromptAPI(lastWords);
            log(speech);
            await stopListening();
          } else {
            initSpeechToText();
          }
          log(lastWords);
        },
        child: Icon(speechToText.isListening ? Icons.pause : Icons.mic),
      ),
    );
  }
}
