import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

// listener cocok utk logika
// StreamBuilder cocok utk update UI

class AudioPage extends StatefulWidget {
  const AudioPage({super.key});

  @override
  State<AudioPage> createState() => _AudioPageState();
}

class _AudioPageState extends State<AudioPage> {
  final player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    player.setUrl("https://musik-ku-api-bmlq-git-main-arsal-fahrullohs-projects.vercel.app/song/1763260494_Jim%20Yosef%20&%20Anna%20Yvette%20-%20Linked%20%20House%20%20NCS%20-%20Copyright%20Free%20Music%20-%20NoCopyrightSounds.mp3");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Steam Builder Just Audio"), backgroundColor: Colors.blue,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            StreamBuilder<ProcessingState>( // jika ada <ProcessingState>
              stream: player.processingStateStream, // maka isi properti stream wajib ProcessingState dan widget stream
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
                StreamBuilder( // jika tidak ada ada <bool>
                  stream: player.playingStream, //maka isi stream bebas asalkan widget stream
                  builder: (context, snapshot) {
                    final isPlaying = snapshot.data ?? false;
                    return IconButton(onPressed: () => isPlaying ? player.pause() : player.play(), icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow));
                  },
                ),
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
            )
          ],
        ),
      ),
    );
  }
}

// Lagu diputar → ada posisi
// Lagu loading → ada buffering
// Lagu selesai → completed
// Playlist → next / prev
// Internet lambat → buffer belum penuh


// player.processingStateStream.listen((state) {
//   if (state == ProcessingState.completed) {
//     print("Audio selesai");
//   }
// });
// | ProcessingState     | Artinya                  |
// | --------- | ---------------------------------- |
// | idle      | Belum ada audio                    |
// | loading   | Lagi load audio                    |
// | buffering | Audio belum siap (internet lambat) |
// | ready     | Siap diputar                       |
// | completed | Lagu selesai                       |
// Bagus digunakan saat:
// Deteksi lagu selesai
// Auto play next
// Ubah UI (loading → play)
// Debug player state


// player.positionStream.listen((position) {
//   print(position);
// });
// Mengetahui posisi waktu saat ini
// ⏱️ contoh: 00:15
// Digunakan untuk: Slider / seek bar, Label waktu, Animasi progress


// player.durationStream.listen((duration) {
//   print(duration);
// });
// Mengetahui panjang total lagu
// 🎵 contoh: 3:45
// Digunakan untuk: Max slider, Total waktu lagu, Hitung persentase progress


// player.bufferedPositionStream.listen((buffered) {
//   print(buffered);
// });
// Mengetahui berapa detik audio SUDAH TERDOWNLOAD
// 🧠 Contoh:
// Durasi lagu: 5 menit
// Buffered: 1:20
// Artinya: Audio baru siap sampai menit 1:20
// Digunakan saat: Streaming audio, Internet lambat, Menampilkan buffer bar (abu-abu di slider)


// player.playingStream.listen((playing) {
//   print(playing);
// });
// true	Playing
// false	Pause
// ✅ Digunakan untuk: Tombol play / pause, Notification media, Lock screen control


// player.currentIndexStream.listen((index) {
//   print(index);
// });
// contoh playlist
// [
//   Song A, // index 0
//   Song B, // index 1
//   Song C, // index 2
// ]
// Digunakan untuk: Next / Prev, Highlight lagu aktif, Update title, cover, artist


// | Stream                 | Fungsi Utama   |
// | ---------------------- | -------------- |
// | positionStream         | Waktu berjalan |
// | durationStream         | Panjang lagu   |
// | bufferedPositionStream | Buffering      |
// | playingStream          | Play / pause   |
// | processingStateStream  | Status player  |
// | currentIndexStream     | Playlist       |