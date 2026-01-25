import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toko/models/song.dart';

class PlaylistPage extends StatefulWidget {
  const PlaylistPage({super.key});

  @override
  State<PlaylistPage> createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final player = AudioPlayer();
  int currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    initSong();
    initListener();
  }

  Future<void> initSong()async{
    final audioSource = ConcatenatingAudioSource(children: playList.map((song) => AudioSource.uri(Uri.parse(song.url))).toList());

    await player.setAudioSource(audioSource);
    player.play();
  }

  void initListener(){
    player.currentIndexStream.listen((i){
      if(i == null) return;
      setState(() {
        currentIndex = i;
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
      appBar: AppBar(title: Text("Playlist"), backgroundColor: Colors.orange,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(playList[currentIndex].title),
            SizedBox(height: 5,),
            StreamBuilder<ProcessingState>(
              stream: player.processingStateStream,
              builder: (context, snapshot) {
                final isComplete = snapshot.data == ProcessingState.completed;
                return Text(isComplete ? "Music Sudah selesai" : "Music sedang diputar");
              },
            ),
            SizedBox(height: 5,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () => player.seekToPrevious(), icon: Icon(Icons.skip_previous)),
                SizedBox(width: 5,),
                StreamBuilder(
                  stream: player.playingStream,
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return IconButton(onPressed: () => isPlaying ? player.pause() : player.play(), icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow));
                  },
                ),
                SizedBox(width: 5,),
                IconButton(onPressed: () => player.seekToNext(), icon: Icon(Icons.skip_next)),
                SizedBox(width: 20,),
                SizedBox(width: 5,),
                StreamBuilder<Duration>(
                  stream: player.positionStream,
                  builder: (context, snapshot) {
                    final position = snapshot.data ?? Duration.zero;
                    return StreamBuilder<Duration?>(
                      stream: player.durationStream,
                      builder: (context, snapshot){
                        final duration = snapshot.data ?? Duration.zero;
                        return Text("${position.inMinutes}m / ${duration.inMinutes}m");
                      },
                    );
                  },
                )
              ],
            ),
            SizedBox(height: 10,),
            StreamBuilder<Duration>(
              stream: player.positionStream,
              builder: (context, snapshot) {
                final postion = snapshot.data ?? Duration.zero;
                return StreamBuilder<Duration?>(
                  stream: player.durationStream,
                  builder: (context, snapshot) {
                    final duration = snapshot.data ?? Duration.zero;
                    return Slider(
                      min: 0,
                      max: duration.inMilliseconds.toDouble(),
                      value: postion.inMilliseconds.clamp(0, duration.inMilliseconds).toDouble(),
                      onChanged: (value) {
                        player.seek(Duration(milliseconds: value.toInt()));
                      },
                    );
                  },
                );
              },
            ),
            Expanded(
              child: ListView.builder(
                itemCount: playList.length,
                itemBuilder: (context, index){
                  final isActive = currentIndex == index;
                  return ListTile(
                    title: Text(playList[index].title,
                    style: TextStyle(
                      color: isActive ? Colors.orange : Colors.black,
                      fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      )
                    ),
                    leading: Icon(isActive ? Icons.pause : Icons.play_arrow),
                    onTap: isActive ? null : () => player.seek(Duration.zero, index: index),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

final playList = [
  Song(title: "Linked", url: "https://musik-ku-api-bmlq-git-main-arsal-fahrullohs-projects.vercel.app/song/1763260494_Jim Yosef & Anna Yvette - Linked  House  NCS - Copyright Free Music - NoCopyrightSounds.mp3"),
  Song(title: "Cyberpunk", url: "https://musik-ku-api-bmlq-git-main-arsal-fahrullohs-projects.vercel.app/song/1763118003_cyber.mp3")
];