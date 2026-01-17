<?php

namespace App\Http\Controllers;

use App\Models\Music;
use Exception;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use ProtoneMedia\LaravelFFMpeg\Support\FFMpeg;

class MusicApiController extends Controller
{
    public function index(){
        $data = Music::all();
        return response()->json(['message' => "Menampilkan semua music", 'success' => true, 'data' => $data]);
    }

    public function create(Request $request){
        $validator = Validator::make($request->all(),[
            'cover' => 'required|image|mimes:png,jpg,jpeg',
            'title' => 'required',
            'artis_name' => 'required',
            'audio' => 'required'
        ]);

        if($validator->fails()){
            return response()->json(['message' => $validator->errors()->all(), 'success' => false]);
        }

        try{
            if($request->hasFile('cover')){
                $cover = $request->file('cover');
                $nmcover = 'cover' . '_' . time() . '.' . $cover->getClientOriginalExtension();
                $cover->storeAs('covers', $nmcover, 'public'); //pindahkan ke folder covers| rename file| pindahkan ke folder storage/app/public
                // $cover->store('covers', 'public'); bisa seperti ini tapi tidak rename file
            }else{
                $nmcover = null;
            }

            // donwload di "https://ffmpeg.org/download.html" dan tambahkan ke path| contohnya ada di porjek YouTube
            // install library ffmpeg
            // composer require pbmedia/laravel-ffmpeg
            if($request->hasFile('audio')){
                $audio = $request->file('audio');
                $nmaudio = 'song' . '_' . time() . '.' . $audio->getClientOriginalExtension();
                // untuk membukanya gunakan perintah "php artisan storage:link" agar bisa di akses link foldernya
                // contoh membuka filenya http://127.0.0.1:8000/storage/songs/song_1768531442.mp3
                //simpan ke folder storage/app/public/songs/nmaudio.mp3
                $audio->storeAs('songs',$nmaudio,'public');
                $duration = FFMpeg::fromDisk('public')->open('songs/' . $nmaudio)->getDurationInSeconds(); //buka file audio dan hitung durasi sonngnya
            }else{
                $nmaudio = null;
                $duration = 0;
            }

            Music::create([
                'cover' => $nmcover,
                'title' => $request->title,
                'artis_name' => $request->artis_name,
                'duration' => $duration,
                'audio' => $nmaudio
            ]);
                return response()->json(['message' => "Music berhasil diupload", 'success' => true]);
            }catch(Exception $e){
                return response()->json(['message' => $e->getMessage(), 'success' => false]);
        }
    }
}
