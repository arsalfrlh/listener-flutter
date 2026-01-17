import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:toko/models/song.dart';

class ApiService {
  final String baseUrl = "http://192.168.0.104:8000/api";

  Future<List<Song>> getAllSong()async{
    try{
      final response = await http.get(Uri.parse("$baseUrl/song"));
      if(response.statusCode == 200){
        return(json.decode(response.body)['data'] as List).map((item) => Song.fromJson(item)).toList();
      }else{
        throw Exception(json.decode(response.body));
      }
    }catch(e){
      throw Exception(e);
    }
  }

  Future<Map<String, dynamic>> addSong(String title, String artisName, XFile cover, File audio)async{
    try{
      final request = http.MultipartRequest("POST", Uri.parse("$baseUrl/song/create"));
      request.fields['title'] = title;
      request.fields['artis_name'] = artisName;
      request.files.add(await http.MultipartFile.fromPath("cover", cover.path));
      request.files.add(await http.MultipartFile.fromPath("audio", audio.path));

      final response = await request.send();
      final responseData = await http.Response.fromStream(response);
      print(json.decode(responseData.body));
      if(responseData.statusCode == 200){
        return json.decode(responseData.body);
      }else{
        return{
          "success": false,
          "message": json.decode(responseData.body)
        };
      }
    }catch(e){
      print(e);
      return{
        "success": false,
        "message": e
      };
    }
  }
}