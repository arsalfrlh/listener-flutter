import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:toko/models/song.dart';
import 'package:toko/pages/tambah_page.dart';
import 'package:toko/services/api_service.dart';

class SongPage extends StatefulWidget {
  const SongPage({super.key});

  @override
  State<SongPage> createState() => _SongPageState();
}

class _SongPageState extends State<SongPage> {
  final ApiService apiService = ApiService();
  List<Song> songList = [];
  bool isLoading = false;
  Duration duration = Duration.zero;
  Duration postion = Duration.zero;
  bool isPlaying = false;
  Song? currentSong;
  int? currentIndex;
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    fetchSong();
    initListener();
  }

  Future<void> fetchSong()async{
    setState(() {
      isLoading = true;
    });
    songList = await apiService.getAllSong();
    setState(() {
      isLoading = false;
    });
  }

  void initListener(){
    player.onDurationChanged.listen((d){
      if(!mounted) return;
      setState(() {
        duration = d;
      });
    });
    player.onPositionChanged.listen((p){
      if(!mounted) return;
      setState(() {
        postion = p;
      });
    });
    player.onPlayerStateChanged.listen((pl){
      if(!mounted) return;
      setState(() {
        isPlaying = pl == PlayerState.playing;
      });
    });
    
    player.onPlayerStateChanged.listen((pl){
      if(pl == PlayerState.completed){
        if(currentIndex != null && songList.length > currentIndex!){
          setState(() {
            currentSong = songList[currentIndex! + 1];
            currentIndex! + 1;
          });
          player.play(UrlSource("http://192.168.0.104:8000/storage/songs/${currentSong!.audio}"));
        }
      }
    });
  }

  void playSong(Song song, int index){
    if(currentSong != null && currentSong!.id == song.id){
      isPlaying ? player.pause() : player.resume();
    }else{
      player.play(UrlSource("http://192.168.0.104:8000/storage/songs/${song.audio}"));
      setState(() {
        currentIndex = index;
        currentSong = song;
      });
    }
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Music"), backgroundColor: Colors.blue,),
      body: RefreshIndicator(
        onRefresh: fetchSong,
        child: isLoading
        ? Center(child: CircularProgressIndicator(),)
        : Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: songList.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => playSong(songList[index], index),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CachedNetworkImage(imageUrl: "http://192.168.0.104:8000/storage/covers/${songList[index].cover}", width: 80, height: 80, fit: BoxFit.cover, errorWidget: (context, url, error) => Icon(Icons.broken_image, size: 80,),),
                        SizedBox(height: 5,),
                        Text("Song: ${songList[index].title}"),
                        SizedBox(height: 5,),
                        Text("Artis: ${songList[index].artisName}"),
                        SizedBox(height: 10,),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: currentSong != null
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Slider(
                      min: 0,
                      max: duration.inMilliseconds.toDouble(),
                      value: postion.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
                      onChanged: (value) {
                        player.seek(Duration(milliseconds: value.toInt()));
                      },
                    ),
                    SizedBox(width: 5,),
                    IconButton(onPressed: () => isPlaying ? player.pause() : player.resume(), icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow)),
                    SizedBox(width: 5,),
                    Text("${postion.inMinutes}m / ${duration.inMinutes}m")
                  ],
                )
                : Text("Silahkan Putar Musik"),
              )
            ],
          )
        ),
      ),
      floatingActionButton: Container(
        color: Colors.green,
        width: 80,
        height: 80,
        child: IconButton(onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => TambahPage())).then((_) => fetchSong());
        }, icon: Icon(Icons.add, color: Colors.white, size: 40,)),
      ),
    );
  }
}