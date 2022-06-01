import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:videodownloader/utils/compare.dart';

class GalleryBloc extends ChangeNotifier {
  ValueNotifier<List<FileSystemEntity>?> notifierFiles =
      ValueNotifier<List<FileSystemEntity>?>(null);

  List<FileSystemEntity>? listAll;
  List<FileSystemEntity>? listVideo;
  List<FileSystemEntity>? listImage;
  List<FileSystemEntity>? listAudio;

  void loadFiles() async {
    var directory = (await getExternalStorageDirectory())!.path;
    var list = Directory("$directory").listSync();
    notifierFiles.value = list;
    listAll = list;
    listVideo = list
            .where(
                (element) => checkConstainsString(element.path, ['mp4', 'mov']))
            .isNotEmpty
        ? list
            .where((element) =>
                checkConstainsString(element.path, ['png', 'jpg', 'jpeg']))
            .toList()
        : [];
    listImage = list
            .where((element) =>
                checkConstainsString(element.path, ['png', 'jpg', 'jpeg']))
            .isNotEmpty
        ? list
            .where((element) =>
                checkConstainsString(element.path, ['png', 'jpg', 'jpeg']))
            .toList()
        : [];
    listAudio = list
            .where((element) => checkConstainsString(element.path, ['mp3']))
            .isNotEmpty
        ? list
            .where((element) =>
                checkConstainsString(element.path, ['png', 'jpg', 'jpeg']))
            .toList()
        : [];
  }

  void onChangeList(int v) {
    switch (v) {
      case 0:
        notifierFiles.value = listAll;
        break;
      case 1:
        notifierFiles.value = listVideo;
        break;
      case 2:
        notifierFiles.value = listImage;
        break;
      default:
        notifierFiles.value = listAudio;
        break;
    }
  }
}
