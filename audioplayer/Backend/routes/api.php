<?php

use App\Http\Controllers\MusicApiController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::get('/song',[MusicApiController::class,'index']);
Route::post('/song/create',[MusicApiController::class,'create']);