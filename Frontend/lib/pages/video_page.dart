import 'package:flutter/material.dart';
import 'package:toko/pages/song_page.dart';
import 'package:toko/pages/text_page.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController videController;
  bool isPlaying = false;
  Duration position = Duration(seconds: 0);
  Duration duration = Duration(seconds: 0);
  bool initialize = false;

  @override
  void initState() {
    super.initState();
    _initListener();
  }

  Future<void> _initListener()async{
    videController = VideoPlayerController.networkUrl(Uri.parse("http://192.168.0.104:8000/video/video.mp4"));
    await videController.initialize().then((_){
      setState(() {
        initialize = true;
      });
    });
    videController.addListener((){ //listener manual hanya ada 1 saja yaitu addListener| listener Stream punya banyak contoh onDurationChanged, onPositionChanged, onPlayerStateChanged
      if(!mounted) return; //jika tidak true hasilnya return ksong
      setState(() {
        isPlaying = videController.value.isPlaying; //set listener apakah videonya sedang berjalan atau tidak
        position = videController.value.position; //set listener posisi video yg sedang diputar saat ini
        duration = videController.value.duration; //set listener posisi durasi yg sedang diputar saat ini s
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    videController.removeListener(_initListener);
    videController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Video Listener"), backgroundColor: Colors.blue,),
      body:Padding(
        padding: const EdgeInsets.all(16.0),
        child: initialize
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Video Controller Listener"),
              SizedBox(height: 10,),
              AspectRatio(
                aspectRatio: videController.value.aspectRatio,
                child: VideoPlayer(videController),
              ),
              SizedBox(height: 10,),
              Slider(
                min: 0,
                max: duration.inMilliseconds.toDouble(), //max durasi slidernya di hitung sesuai miliSeconds | inDays, inHours, inMicrosecond, inMinutes, inSeconds
                value: position.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(), //posisi Slider yang bergerak sekarang saat play postion dan duration
                onChanged: (value)async{
                  videController.seekTo(Duration(milliseconds: value.toInt())); //saat di geser Slidernya dan pergeserannya di hitung dengan milisecond | Days, Hours, Microsecond, Minutes, Seconds
                },
              ),
              SizedBox(height: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(onPressed: (){
                    setState(() {
                      isPlaying ? videController.pause() : videController.play();
                    });
                  }, icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, size: 24,)),
                  Text("${position.inSeconds}s / ${duration.inSeconds}s") //tampilkan waktu video yang sekarang di putar(position) dan durasi (duration) pemutaran video dalam second
                ],
              )
            ],
          )
        : const Center(child: CircularProgressIndicator(),)
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => TextPage()));
          }, icon: Icon(Icons.edit)),
          IconButton(onPressed: (){}, icon: Icon(Icons.video_chat_rounded)),
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => SongPage()));
          }, icon: Icon(Icons.music_note)),
        ],
      ),
    );
  }
}