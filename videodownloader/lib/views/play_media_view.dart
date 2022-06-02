import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:videodownloader/utils/compare.dart';
import 'package:videodownloader/views/audio_view.dart';
import 'package:videodownloader/views/image_view.dart';
import 'package:videodownloader/views/video_view.dart';

class PlayMediaView extends StatefulWidget {
  final String path;

  const PlayMediaView({Key? key, required this.path}) : super(key: key);

  @override
  State<PlayMediaView> createState() => _PlayMediaViewState();
}

class _PlayMediaViewState extends State<PlayMediaView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  int? loadEnpoint(String url) {
    if (checkConstainsString(url, ['mp4', 'mov'])) {
      return 1;
    } else if (checkConstainsString(url, ['jpeg', 'jpg', 'png'])) {
      return 2;
    } else if (checkConstainsString(url, ['m4a', 'mp3', 'ogg', 'wav'])) {
      return 3;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                  margin: const EdgeInsets.all(16),
                  child: const Icon(Icons.arrow_back,
                      size: 24, color: Colors.white)),
            ),
            Expanded(child: content())
          ],
        )));
  }

  content() {
    switch (loadEnpoint(widget.path)) {
      case 1:
        return VideoView(
          path: widget.path,
        );
      case 2:
        return ImageView(
          path: widget.path,
        );
      case 3:
        return AudioView(
          path: widget.path,
        );
      default:
        return Container();
    }
  }
}
