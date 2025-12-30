import 'package:flutter/material.dart';
import 'package:toko/pages/text_page.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Listener Flutter",
      home: TextPage(),
    );
  }
}

//php artisan serve --host=0.0.0.0 --port=8000
// {'Content-Type': 'application/json'}
// http://192.168.1.245:8000
//192.168.1.245 cek dengan ipconfig di cmd
//http://192.168.0.104:8000/api khusus emulator

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return const Placeholder();
//   }
// }