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

class _VideoViewState extends State<VideoView> with SingleTickerProviderStateMixin {
  VideoPlayerController? _controller;

  // ChewieController? _chewieController;
  double minDuration = 0;
  double maxDuration = 0;
  double currentDuration = 0;
  String currentTime = "", endTime = "";
  AnimationController? _animationController;
  bool isPlaying = false;
  bool isShowController = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(microseconds: 300));
    initPlayer();
  }

  initPlayer() async {
    _controller = VideoPlayerController.file(File(widget.path!));
    await _controller!.initialize();
    // _chewieController = ChewieController(
    //     videoPlayerController: _controller!,
    //     autoPlay: true,
    //     allowedScreenSleep: false,
    //     allowFullScreen: true,
    //     deviceOrientationsAfterFullScreen: [
    //       DeviceOrientation.landscapeRight,
    //       DeviceOrientation.landscapeLeft,
    //       DeviceOrientation.portraitUp,
    //       DeviceOrientation.portraitDown,
    //     ],
    //     autoInitialize: true,
    //     aspectRatio: _aspectRatio,
    //     showControls: false,
    //     showControlsOnInitialize: false);
    changeStatusPlaying();
    setState(() {
      maxDuration = _controller!.value.duration.inMilliseconds.toDouble();
      currentTime = getDuration(_controller!.value.position.inMilliseconds.toDouble());
      endTime = getDuration(maxDuration);
    });
    _visibleControl();
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

  _visibleControl() async {
    if (isShowController == true) {
      setState(() {
        isShowController = false;
      });
    } else {
      setState(() {
        isShowController = true;
      });
      // await Future.delayed(
      //   const Duration(seconds: 3),
      //   () {
      //     setState(() {
      //       isShowController = false;
      //     });
      //   },
      // );
      // await  Future.delayed(const Duration(microseconds: 2500));

    }
  }

  String getDuration(double value) {
    Duration duration = Duration(milliseconds: value.round());
    return [duration.inHours, duration.inMinutes, duration.inSeconds]
        .map((e) => e.remainder(60).toString().padLeft(2, "0"))
        .join(":");
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller?.dispose();
    // _chewieController?.dispose();
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
    return OrientationBuilder(
      builder: (BuildContext context, Orientation orientation) {
        double aspectRaio = 0.0;
        if (orientation == Orientation.portrait) {
          aspectRaio = 3 / 2;
        } else {
          aspectRaio = 16 / 9;
        }
        return Stack(
          children: [
            Positioned(
              child: _controller != null
                  ? (orientation == Orientation.portrait
                      ? Center(
                          child: AspectRatio(
                            aspectRatio: aspectRaio,
                            child: VideoPlayer(_controller!),
                          ),
                        )
                      : AspectRatio(
                          aspectRatio: aspectRaio,
                          child: VideoPlayer(_controller!),
                        ))
                  // Container(
                  //               margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  //               child: Center(
                  //                 child: ClipRRect(
                  //                   borderRadius: BorderRadius.circular(8.0),
                  //                   child: AspectRatio(
                  //                     aspectRatio: _aspectRatio,
                  //                     child: VideoPlayer(_controller!),
                  //                   ),
                  //                   // child: Chewie(
                  //                   //   controller: _chewieController!,
                  //                   // ),
                  //                 ),
                  //               ),
                  //             )
                  : Container(),
              top: 0,
              right: 0,
              left: 0,
              bottom: 0,
            ),
            Positioned(
                child: GestureDetector(
                    child: Container(
                      color: Colors.transparent,
                    ),
                    onTap: () => _visibleControl()),
                top: 0,
                right: 0,
                bottom: 0,
                left: 0),
            Positioned(
              child: AnimatedOpacity(
                opacity: isShowController ? 1 : 0,
                duration: const Duration(microseconds: 500),
                child: ValueListenableBuilder(
                  builder: (BuildContext context, VideoPlayerValue value, Widget? child) {
                    currentDuration = value.position.inMilliseconds.toDouble();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Text(
                            getDuration(value.position.inMilliseconds.toDouble()) +
                                " | " +
                                getDuration(value.duration.inMilliseconds.toDouble()),
                            style: const TextStyle(color: Color(0xFF7E909E)),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                          height: 40,
                          child: Row(
                            children: [
                              SizedBox(
                                child: GestureDetector(
                                  onTap: () {
                                    changeStatusPlaying();
                                  },
                                  child: AnimatedIcon(
                                    icon: AnimatedIcons.play_pause,
                                    progress: _animationController!,
                                    color: const Color(0xFF7E909E),
                                    size: 24,
                                  ),
                                ),
                                width: 24,
                              ),
                              Expanded(
                                  child: Container(
                                child: Slider(
                                  value: value.position.inMilliseconds.toDouble(),
                                  min: minDuration,
                                  max: maxDuration,
                                  activeColor: Colors.lightBlue,
                                  inactiveColor: const Color(0xFF7E909E),
                                  thumbColor: const Color(0xFF7E909E),
                                  onChanged: (v) {
                                    print(v);
                                    setState(() {
                                      currentDuration = v;
                                    });
                                  },
                                  onChangeEnd: (c) {
                                    _controller!.seekTo(Duration(milliseconds: c.toInt()));
                                  },
                                  onChangeStart: (c) {
                                    print(c);
                                  },
                                ),
                                margin: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                              ))
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    reverseDuration(value.position.inMilliseconds.toDouble()),
                                child: Container(
                                  child: Image.asset(
                                    'assets/images/reverse.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  alignment: Alignment.centerRight,
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 16,
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () =>
                                    forwardDuration(value.position.inMilliseconds.toDouble()),
                                child: Container(
                                  child: Image.asset(
                                    'assets/images/forward.png',
                                    width: 24,
                                    height: 24,
                                  ),
                                  alignment: Alignment.centerLeft,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        )
                      ],
                    );
                  },
                  valueListenable: _controller!,
                ),
              ),
              right: 0,
              left: 0,
              bottom: 16,
              height: 140,
            )
          ],
        );
      },
    );
  }

  reverseDuration(double currentDuration) {
    var sec = 0.0;
    if (currentDuration <= 10000) {
      sec = 0;
    } else {
      sec = (currentDuration - 10000);
    }
    _controller!.seekTo(Duration(milliseconds: sec.toInt()));
  }

  forwardDuration(double currentDuration) {
    var sec = (currentDuration + 10000);
    if (sec > maxDuration) {
      sec = maxDuration;
    }
    _controller!.seekTo(Duration(milliseconds: sec.toInt()));
  }

  void changeStatusPlaying() {
    setState(() => isPlaying = !isPlaying);
    isPlaying ? _controller!.play() : _controller!.pause();
    !_animationController!.isCompleted
        ? _animationController!.forward()
        : _animationController!.reverse();
  }
}
