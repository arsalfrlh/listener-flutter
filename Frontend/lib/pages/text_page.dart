import 'package:flutter/material.dart';
import 'package:toko/pages/song_page.dart';
import 'package:toko/pages/video_page.dart';

class TextPage extends StatefulWidget {
  const TextPage({super.key});

  @override
  State<TextPage> createState() => _TextPageState();
}

class _TextPageState extends State<TextPage> {
  final textContoller = TextEditingController();
  String typedText = "";
  bool isTyping = false;

  @override
  void initState() {
    super.initState();
    _initListener();
  }
  
  void _initListener(){
    textContoller.addListener((){
      if(!mounted) return;
      setState(() {
        isTyping = mounted;
        typedText = textContoller.text;
        print("Typing: ${textContoller.text}");
      });
    });
  }

  @override
  void dispose() {
    textContoller.removeListener(_initListener);
    textContoller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Listener TextController"), backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Anda menginput: $typedText"),
            SizedBox(height: 24,),
            Text(isTyping ? "Sedang Mengetik..." : "Tidak Mengetik"),
            SizedBox(height: 24,),
            TextField(
              controller: textContoller,
              decoration: InputDecoration(
                labelText: "Input Text"
              ),
            ),
            // TextField(
            //   onChanged: (value){ //listener tanpa kontroller
            //     print("Text: $value");
            //   },
            //   decoration: InputDecoration(
            //     labelText: "Input Text"
            //   ),
            // )
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: (){}, icon: Icon(Icons.edit)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPage()));
          }, icon: Icon(Icons.video_chat_rounded)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SongPage()));
          }, icon: Icon(Icons.music_note)),
        ],
      ),
    );
  }
}