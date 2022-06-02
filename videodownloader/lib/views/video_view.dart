import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class VideoView extends StatefulWidget {
  final String? path;
  const VideoView({Key? key, this.path}) : super(key: key);

  @override
  State<VideoView> createState() => _VideoViewState();
}

class _VideoViewState extends State<VideoView> {
  VideoPlayerController? _controller;
  ChewieController? _chewieController;
  final double _aspectRatio = 16 / 9;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initPlayer();
  }

  initPlayer() async {
    _controller = VideoPlayerController.file(File(widget.path!));
    await _controller!.initialize();
    _chewieController = ChewieController(
        videoPlayerController: _controller!,
        autoPlay: true,
        allowedScreenSleep: false,
        allowFullScreen: true,
        deviceOrientationsAfterFullScreen: [
          DeviceOrientation.landscapeRight,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        autoInitialize: true,
        aspectRatio: _aspectRatio,
        showControls: false,
        showControlsOnInitialize: false);
    setState(() {});
    // _chewieController!.addListener(() {
    //   if (_chewieController!.isFullScreen) {
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.landscapeRight,
    //       DeviceOrientation.landscapeLeft,
    //     ]);
    //   }
    //   else {
    //     SystemChrome.setPreferredOrientations([
    //       DeviceOrientation.portraitUp,
    //       DeviceOrientation.portraitDown,
    //     ]);
    //   }
    // });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    _chewieController?.dispose();
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.landscapeRight,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    // ]);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _chewieController != null
        ? Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: GestureDetector(
          onLongPressStart: (d) {
            _chewieController!.pause();
          },
          onLongPressEnd: (d) {
            _chewieController!.play();
          },
          onTap: () {
            if (_chewieController!.isPlaying) {
              _chewieController!.pause();
            } else {
              _chewieController!.play();
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Chewie(
              controller: _chewieController!,
            ),
          )),
    )
        : Container();
  }

}
