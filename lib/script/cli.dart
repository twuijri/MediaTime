import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:flutter/material.dart';

var videoNum;
var photoNum;
var audioNum;

var videoTime;
var audioTime;

var fileMedia = [];
var fileError = [];


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
