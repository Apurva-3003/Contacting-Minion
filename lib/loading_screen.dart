import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:talking_with_minions/networking.dart';
import 'package:talking_with_minions/chat_screen.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  //instance of audiocache class
  final cache = AudioCache();

  //instance of audioplayers package is defined
  AudioPlayer player;

  @override
  void initState() {
    super.initState();
    //keep on playing music while we wait for web data from API
    playMusic();
    //Do all the processing and getting data off the web here (write somewhere else though)
  }

  void playMusic() async {
    player = await cache.loop('minions-banana-song.mp3');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.network('https://thumbs.gfycat.com/AlertNastyGrunion-size_restricted.gif'),
          ElevatedButton(
            child: Text(
              'Talk With Minion!',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            onPressed: () {
              // ? means that it'll only stop if its on in the first place
              player?.stop();
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return ChatScreen();
                }),
              );
            },
          )
        ],
      ),
    );
  }
}
