import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
// import 'script/cli.dart' as cli;

// int calculate() {
//   return 100 * 7;
// }
//
//
// void main1(List<String> arguments) {
//   print('Hello world: ${calculate()}!');
// }

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF121212),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  runApp(
    MaterialApp(
      home: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var videoNum = 0;
  var photoNum = 0;
  var audioNum = 0;

  var videoTime;
  var audioTime;

  var fileMedia = [];
  var fileError = [];

  void getDir() async {
    String? selectedDirectory = await FilePicker.platform.getDirectoryPath();
    print(selectedDirectory);
    scriptFunction(selectedDirectory.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Files',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getDir();

        },
        child: Icon(Icons.attachment_outlined),
      ),
      body: Center(
        child: shoeData(),
      ),
    );
  }

  Widget shoeData() {


    return ListView(
      scrollDirection:
          MediaQuery.of(context).size.height > MediaQuery.of(context).size.width
              ? Axis.vertical
              : Axis.horizontal,
      children: [
        if (MediaQuery.of(context).size.height <=
            MediaQuery.of(context).size.width)
          const SizedBox(
            width: 16.0,
          ),
        SingleChildScrollView(
          scrollDirection: MediaQuery.of(context).size.height >
                  MediaQuery.of(context).size.width
              ? Axis.horizontal
              : Axis.vertical,
          child: DataTable(
            columns: const [
              DataColumn(
                label: Text(
                  'Property',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DataColumn(
                label: Text(
                  'Value',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            rows: [
              DataRow(
                cells: [
                  DataCell(Text('number of videos')),
                  DataCell(Text(videoNum.toString())),

                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('number of photos')),
                  DataCell(Text(photoNum.toString())),
                ],
              ),
              DataRow(
                cells: [
                  DataCell(Text('number of audios')),
                  DataCell(Text(audioNum.toString())),

                ],
              ),
            ],
          ),
        )

      ],
    );
  }






  void scriptFunction(String pathURL) async {

    videoNum = 0;
    photoNum = 0;
    audioNum = 0;

    videoTime = 0;
    audioTime = 0;

    fileMedia = [];
    fileError = [];

    var videoName = [
      ".mp4",
      ".MP4",
      ".mxf",
      ".MXF",
      ".mts",
      ".MTS",
      ".mov",
      ".MOV"
    ];
    var photoName = [
      ".png",
      ".PNG",
      ".jpg",
      ".JPG",
      ".jpeg",
      ".JPEG",
      ".nef",
      ".NEF",
      ".cr2",
      ".CR2",
      ".dng",
      ".DNG"
    ];
    var audioName = [".mp3", ".MP3", "wav", "WAV"];
    var allMedia = videoName + photoName + audioName;

    Directory dir = new Directory(pathURL);
    List<FileSystemEntity> files = dir.listSync(recursive: true);
    for (FileSystemEntity fileOrDir in files) {
      setState(() {

      });
      var p = fileOrDir.path;

      for (var prop in allMedia) {
        if (p.endsWith(prop)) {
          if (videoName.contains(prop)) {
            if ((fileOrDir is File)) {
              fileMedia.add(fileOrDir.path);
              videoNum++;



              /// Use [MetadataRetriever.fromFile] on Windows, Linux, macOS, Android or iOS.
              MetadataRetriever.fromFile(
                File(fileOrDir.path),
              )
                ..then(
                      (metadata) {
                    videoTime =
                        videoTime + int.parse('${metadata.trackDuration}');
                  },
                )
                ..catchError((_) {
                  fileError.add(fileOrDir.path);
                });
            } else if (fileOrDir is Directory) {
            }
          }
          if (photoName.contains(prop)) {
            if ((fileOrDir is File)) {
              fileMedia.add(fileOrDir.path);
              photoNum++;
            } else if (fileOrDir is Directory) {
              // print(fileOrDir.path);
            }
          }
          if (audioName.contains(prop)) {
            if ((fileOrDir is File)) {
              fileMedia.add(fileOrDir.path);
              audioNum++;

              /// Use [MetadataRetriever.fromFile] on Windows, Linux, macOS, Android or iOS.
              MetadataRetriever.fromFile(
                File(fileOrDir.path),
              )
                ..then(
                      (metadata) {
                    audioTime =
                        audioTime + int.parse('${metadata.trackDuration}');
                  },
                )
                ..catchError((_) {
                  fileError.add(fileOrDir.path);
                });
            } else if (fileOrDir is Directory) {
              // print(fileOrDir.path);
            }
          }
        }
      }
    }
    // print("video number: $videoNum");
    // print("photo number: $photoNum");
    // print("audio number: $audioNum");
  }
}
