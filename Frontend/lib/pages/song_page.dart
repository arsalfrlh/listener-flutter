import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:toko/pages/text_page.dart';
import 'package:toko/pages/video_page.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final player = AudioPlayer();
  Duration position = Duration(seconds: 0);
  Duration duration = Duration(seconds: 0);
  bool isPlaying = false;
  bool initialize = false;

  @override
  void initState() {
    super.initState();
    _initListener();
  }
  
  void _initListener(){
    player.onPositionChanged.listen((p){
      if(!mounted) return;
      setState(() {
        position = p;
      });
    });

    player.onDurationChanged.listen((d){
      if(!mounted) return;
      setState(() {
        duration = d;
      });
    });

    player.onPlayerStateChanged.listen((p){
      if(!mounted) return;
      setState(() {
        isPlaying = p == PlayerState.playing; //jika p sama dgn PlayerState.playing maka bernillai true artinya player memutar music
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    player.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Audio Player Listener"), backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Audio Listener"),
            SizedBox(height: 10,),
            Slider(
              min: 0,
              max: duration.inMilliseconds.toDouble(), //max slide bergeser
              value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(), //position sekarang yg bergeser ke duration
              onChanged: (value) { //saat di geser akan pindah dan position juga ikut pindah karna listener di initState| listener langsung
                player.seek(Duration(milliseconds: value.toInt()));
              },
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(onPressed: ()async{
                  initialize
                  ? isPlaying ? player.pause() : player.resume()
                  : await player.play(UrlSource("http://192.168.0.104:8000/song/song.mp3")).then((_) => setState(() => initialize = true));
                }, icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 24,)),
                Text("${position.inMinutes}m / ${duration.inMinutes}m")
              ],
            ),
          ],
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => TextPage()));
          }, icon: Icon(Icons.edit)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => VideoPage()));
          }, icon: Icon(Icons.video_chat_rounded)),
          IconButton(onPressed: (){}, icon: Icon(Icons.music_note)),
        ],
      ),
    );
  }
}