import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;
  File? _video;
  

  Future pickVideo(ImageSource source) async {
    final video = await ImagePicker().pickVideo(source: source);
    if (video == null) return;
    final videoTemp = File(video.path);
    setState(() {
      this._video = videoTemp;
    });
  }

  Future pickImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imageTemporary = File(image.path);
      setState(() {
        this._image = imageTemporary;
      });
    } on PlatformException catch (e) {
      print("Unable to pick image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber.shade300,
      appBar: AppBar(
        title: Text("Pick Image & Video"),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
         children: [
          _image != null
              ? ClipOval(
                  child: Image.file(
                    _image!,
                    width: 160,
                    height: 160,
                    fit: BoxFit.cover,
                  ),
                )
              : FlutterLogo(size: 160),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
              onPressed: () {
                pickImage(ImageSource.gallery);
              },
              child: Text("Pick image Gallery")),
          const SizedBox(
            height: 12,
          ),
          ElevatedButton(
              onPressed: () {
                pickImage(ImageSource.camera);
              },
              child: Text("Pick image Camera")),
          SizedBox(
            height: 12,
          ),
          ElevatedButton(
              onPressed: () {
                pickVideo(ImageSource.gallery);
              },
              child: Text("Pick video Gallery")),
          ElevatedButton(
              onPressed: () {
                pickVideo(ImageSource.camera);
              },
              child: Text("Pick video Camera")),

        ]),
      ),
    );
  }
}
