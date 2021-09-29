import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:avatar_glow/avatar_glow.dart';
import 'package:talking_with_minions/networking.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //Initializing / Declaring environment variables
  stt.SpeechToText speech = stt.SpeechToText();
  bool isListening = false;
  double confidence = 1.0;
  String userText = 'Press Button and Start Speaking';
  Networking networking = new Networking();
  String translation = 'In minion tongue...';
  FlutterTts flutterTts = new FlutterTts();

  //function to check and record user's voice
  void listen() async {
    if (!isListening) {
      bool available = await speech.initialize(
        onStatus: (val) {
          print('onStatus: $val');
        },
        onError: (val) {
          print('onError: $val');
        },
      );
      if (available) {
        setState(() {
          isListening = true;
        });
        speech.listen(onResult: (val) {
          setState(() {
            userText = val.recognizedWords;
            if (val.hasConfidenceRating && val.confidence > 0) {
              confidence = val.confidence;
            }
          });
        });
      }
    } else {
      setState(() {
        isListening = false;
        print(userText);
        getTranslation();
      });
      speech.stop();
    }
  }

  //function to get translation of user's words in minion language off the web
  Future getTranslation() async {
    try {
      String data = await networking.networkHelper(userText: userText);
      setState(() {
        translation = data;
        print('the translation is: $translation');
      });
    } catch (e) {
      print(e);
    }
  }

  //function to make the minion speak
  Future minionResponse() async {
    if (translation == 'In minion tongue...') {
      return;
    } else {
      await flutterTts.setPitch(1.7);
      await flutterTts.setLanguage("cs-CZ");
      await flutterTts.speak(translation);
    }
  }

  //User Interface always in the build method:-
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow[800],
        centerTitle: true,
        title: Text('Text Accuracy: ${(confidence * 100).toStringAsFixed(1)}%', style: GoogleFonts.play(),),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        color: Colors.blue,
        child: Center(
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Text(
                      userText,
                      style: GoogleFonts.average(
                          fontSize: 25, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    child: Text(
                      translation ??= 'In minion tongue...',
                      style: GoogleFonts.bubblegumSans(
                          color: Colors.yellow, fontSize: 25),
                    ),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: AvatarGlow(
                      repeat: true,
                      glowColor: Colors.red,
                      repeatPauseDuration: const Duration(milliseconds: 100),
                      endRadius: 75,
                      duration: const Duration(milliseconds: 2000),
                      animate: isListening,
                      child: FloatingActionButton(
                        backgroundColor: Colors.yellow[800],
                        child: Icon(isListening ? Icons.mic : Icons.mic_off),
                        onPressed: listen,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: ElevatedButton(
                      onPressed: (){
                        minionResponse();
                      },
                      child: Text(
                        'Listen to Mini the Minion',
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
