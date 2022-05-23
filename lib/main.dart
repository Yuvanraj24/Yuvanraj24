import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:testing_app_dodo/views/homeView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: HomeScreen()
    );
  }
}




class ImagePickerApp extends StatefulWidget {
  const ImagePickerApp({Key? key}) : super(key: key);

  @override
  State<ImagePickerApp> createState() => _ImagePickerAppState();
}

class _ImagePickerAppState extends State<ImagePickerApp> {
  File? _image;
  File? _video;

  Future getVideo() async {
    final video = await ImagePicker().pickVideo(source: ImageSource.gallery);
    if (video == null) return;
    final videoTemp = File(video.path);
    setState(() {
      this._video = videoTemp;
    });
  }

  Future getImage(ImageSource source) async {
    try {
      final image = await ImagePicker().pickImage(source: source);
      if (image == null) return;

      final imagePermanent = await saveFilePermanently(image.path);

      setState(() {
        this._image = imagePermanent;
      });
    } on PlatformException catch (e) {
      print("Unable to pick image $e");
    }
  }

  Future<File> saveFilePermanently(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File("${directory.path}/$name");

    return File(imagePath).copy(image.path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Image Picker"),
        ),
        body: Center(
          child: Column(
            children: [
              _image != null
                  ? Image.file(
                      _image!,
                      width: 250,
                      height: 350,
                      fit: BoxFit.cover,
                    )
                  : Image.network(
                      "https://c4.wallpaperflare.com/wallpaper/489/664/38/women-actress-redhead-scarlett-johansson-wallpaper-preview.jpg",
                      height: 200,
                    ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () {
                    getImage(ImageSource.gallery);
                  },
                  child: Text("Pick from gallery")),
              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                  onPressed: () {
                    getImage(ImageSource.camera);
                  },
                  child: Text("Pick from camera"))
            ],
          ),
        ));
  }
}
