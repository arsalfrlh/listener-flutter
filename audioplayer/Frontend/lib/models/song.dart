class Song {
  final int id;
  final String cover;
  final String title;
  final String artisName;
  final int duration;
  final String audio;

  Song({required this.id, required this.cover, required this.title, required this.artisName, required this.duration, required this.audio});
  factory Song.fromJson(Map<String, dynamic> json){
    return Song(
      id: json['id'],
      cover: json['cover'],
      title: json['title'],
      artisName: json['artis_name'],
      duration: json['duration'],
      audio: json['audio']
    );
  }
}