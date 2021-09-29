import 'package:flutter/material.dart';
import 'package:talking_with_minions/loading_screen.dart';

void main() {
  runApp(
    MaterialApp(
      title: "Talk With Minion",
      home: LoadingScreen(),
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
    ),
  );
}
