import 'package:flutter/material.dart';
import 'package:toko/pages/song_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Gemini",
      home: SongPage(),
    );
  }
}
