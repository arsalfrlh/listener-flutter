import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:toko/services/api_service.dart';

class TambahPage extends StatefulWidget {
  const TambahPage({super.key});

  @override
  State<TambahPage> createState() => _TambahPageState();
}

class _TambahPageState extends State<TambahPage> {
  final ApiService apiService = ApiService();
  final titleController = TextEditingController();
  final artisNameController = TextEditingController();
  XFile? cover;
  File? audio;

  void _add(BuildContext context)async{
    if(titleController.text.isNotEmpty && artisNameController.text.isNotEmpty && cover != null && audio != null){
      showDialog(
        context: context, 
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator(),));

      final response = await apiService.addSong(titleController.text, artisNameController.text, cover!, audio!);
      Navigator.of(context, rootNavigator: true).pop();
      if(response['success'] == true){
        AwesomeDialog(
          context: context,
          dialogType: DialogType.success,
          animType: AnimType.bottomSlide,
          dismissOnTouchOutside: false,
          title: "Sukses",
          desc: response['message'],
          btnOkOnPress: (){
            Navigator.pop(context);
          }
        ).show();
      }else{
        AwesomeDialog(
          context: context,
          dialogType: DialogType.error,
          animType: AnimType.bottomSlide,
          dismissOnTouchOutside: false,
          title: "Error",
          desc: response['message'].toString(),
          btnOkOnPress: (){},
          btnOkColor: Colors.red
        ).show();
      }
    }
  }

  void _pickCover()async{
    final pilih = await ImagePicker().pickImage(source: ImageSource.gallery);
    if(pilih != null){
      setState(() {
        cover = pilih;
      });
    }
  }

  void _pickAudio()async{
    final pilih = await FilePicker.platform.pickFiles(type: FileType.audio);
    if(pilih != null){
      setState(() {
        audio = File(pilih.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFF00BF6D),
        foregroundColor: Colors.white,
        title: const Text("Upload Music Anda"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            ProfilePic(
              image: cover?.path,
              imageUploadBtnPress: _pickCover,
            ),
            SizedBox(height: 24,),
            TextButton(onPressed: _pickAudio, child: Text(audio != null ? audio!.path.split("/").last : "Upload Lagu Anda")),
            const Divider(),
            Form(
              child: Column(
                children: [
                  UserInfoEditField(
                    text: "Judul Lagu",
                    child: TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                  UserInfoEditField(
                    text: "Nama Artis",
                    child: TextFormField(
                      controller: artisNameController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFF00BF6D).withOpacity(0.05),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16.0 * 1.5, vertical: 16.0),
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context)
                          .textTheme
                          .bodyLarge!
                          .color!
                          .withOpacity(0.08),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 16.0),
                SizedBox(
                  width: 160,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00BF6D),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () => _add(context),
                    child: const Text("Upload Music"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ProfilePic extends StatelessWidget {
  const ProfilePic({
    super.key,
    this.image,
    required this.imageUploadBtnPress,
  });

  final String? image;
  final VoidCallback imageUploadBtnPress;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color:
              Theme.of(context).textTheme.bodyLarge!.color!.withOpacity(0.08),
        ),
      ),
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(50),
            child: image != null
            ? Image.file(File(image!), fit: BoxFit.cover, width: 80, height: 80, errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 80,),)
            : Icon(Icons.broken_image, size: 80,),
          ),
          InkWell(
            onTap: imageUploadBtnPress,
            child: CircleAvatar(
              radius: 13,
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(
                Icons.add,
                color: Colors.white,
                size: 20,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UserInfoEditField extends StatelessWidget {
  const UserInfoEditField({
    super.key,
    required this.text,
    required this.child,
  });

  final String text;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0 / 2),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(text),
          ),
          Expanded(
            flex: 3,
            child: child,
          ),
        ],
      ),
    );
  }
}