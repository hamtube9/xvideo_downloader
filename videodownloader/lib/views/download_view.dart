import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';
import 'package:videodownloader/bloc/gallery_bloc.dart';
import 'package:videodownloader/bloc/gallery_provider.dart';
import 'package:videodownloader/bloc/main_bloc.dart';
import 'package:videodownloader/bloc/main_provider.dart';
import 'package:videodownloader/main.dart';
import 'package:videodownloader/views/gallery_view.dart';

class DownloadView extends StatefulWidget {
  const DownloadView({Key? key}) : super(key: key);

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  // final imgUrl =  "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4";
  bool downloading = false;
  var progressString = "";
  late VideoPlayerController _controller;
  bool isShowButton = false;
  bool isPlaying = false;
  PermissionStatus status = PermissionStatus.denied;

  FocusNode? _focusSearch;
  TextEditingController? _searchController;
  TextEditingController? _urlController;
  MainBloc? bloc;

  @override
  void initState() {
    super.initState();
    bloc = MainProvider.of(context);
    _focusSearch = FocusNode();
    _searchController = TextEditingController();
    _urlController = TextEditingController();
    _controller = VideoPlayerController.network(
        'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4')
      ..initialize().then((_) {
        setState(() {});
      });
    // permission();
  }

  autoHideButton() {
    Future.delayed(const Duration(milliseconds: 2000)).whenComplete(() {
      setState(() {
        isShowButton = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height * 0.57,
              child: Stack(
                children: [
                  Positioned(
                    child: Container(
                      decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(60),
                              bottomRight: Radius.circular(60))),
                    ),
                    height: height * 0.45,
                    top: 0,
                    right: 0,
                    left: 0,
                  ),
                  Positioned(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: logo(),
                          flex: 2,
                        ),
                        Expanded(
                          child: inputLinkUrl(),
                          flex: 3,
                        )
                      ],
                    ),
                    top: 0,
                    right: 16,
                    left: 16,
                    bottom: 0,
                  ),
                ],
              ),
            ),
            private_media(),
            fb_stories()
          ],
        ),
      ),
    );
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
    _focusSearch!.unfocus();
  }

  alo() {
    return Center(
      child: downloading
          ? SizedBox(
              height: 120.0,
              width: 200.0,
              child: Card(
                color: Colors.black,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const CircularProgressIndicator(),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      "Downloading File: $progressString",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            )
          : Column(
              children: [
                Expanded(
                    child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _controller.value.isInitialized
                          ? AspectRatio(
                              aspectRatio: _controller.value.aspectRatio,
                              child: Stack(
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isShowButton = !isShowButton;
                                        });
                                        autoHideButton();
                                      },
                                      child: VideoPlayer(_controller)),
                                  isShowButton
                                      ? Center(
                                          child: GestureDetector(
                                            onTap: () async {
                                              setState(() {
                                                isPlaying = !isPlaying;
                                              });
                                              if (isPlaying) {
                                                await _controller.play();
                                              } else {
                                                _controller.pause();
                                              }
                                              autoHideButton();
                                            },
                                            child: Icon(
                                              isPlaying
                                                  ? Icons.pause
                                                  : Icons.play_arrow,
                                              size: 48,
                                              color: Colors.white,
                                            ),
                                          ),
                                        )
                                      : const Center()
                                ],
                              ),
                            )
                          : Container(),
                      TextButton(
                          onPressed: () {
                            // downloadFile();
                          },
                          child: const Text(
                            'download',
                            style: TextStyle(color: Colors.black26),
                          ))
                    ],
                  ),
                ))
              ],
            ),
    );
  }

  iconSupport() {
    return Container(
      child: Column(
        children: [
          Container(
            child: const Center(
              child: Icon(
                Icons.more_horiz,
                color: Colors.white,
                size: 24,
              ),
            ),
            decoration: BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.circular(16)),
            height: 40,
            width: 40,
          ),
          const Text(
            'Facebook',
            style: TextStyle(color: Colors.black),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  iconFb() {
    return GestureDetector(
      onTap: () {
        bloc!.launchFb();
      },
      child: Column(
        children: [
          Image.asset(
            'assets/images/facebook.png',
            height: 40,
            width: 40,
          ),
          const Text(
            'Facebook',
            style: TextStyle(color: Colors.black),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  iconInsta() {
    return GestureDetector(
      onTap: () {
        bloc!.launchInsta();
      },
      child: Column(
        children: [
          Image.asset(
            'assets/images/instagram.png',
            height: 40,
            width: 40,
          ),
          const Text(
            'Instagram',
            style: const TextStyle(color: Colors.black),
          )
        ],
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
      ),
    );
  }

  logo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'assets/images/xvideodownloader.png',
          height: 80,
          width: 80,
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 16),
          child: Text(
            'Video Downloader',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ],
    );
  }

  inputLinkUrl() {
    return Stack(
      children: [
        Positioned(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 3),
                      color: Colors.grey.shade200,
                      blurRadius: 3,
                      spreadRadius: 2)
                ],
                borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Column(
              children: [
                const SizedBox(
                  height: 56,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(12),
                              bottomLeft: Radius.circular(12)),
                          boxShadow: [
                            BoxShadow(
                                offset: const Offset(-1, 3),
                                blurRadius: 2,
                                spreadRadius: 2,
                                color: Colors.grey.shade200)
                          ]),
                      child: TextField(
                        controller: _urlController,
                        style: const TextStyle(
                            fontFamily: "SourceSerifPro",
                            color: Colors.black,
                            fontWeight: FontWeight.w400),
                        onChanged: (value) {
                          //  loginHelper.checkEmail(value);
                        },
                        decoration: InputDecoration(
                            contentPadding: const EdgeInsets.all(10),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            hintText: 'Video URL here...',
                            alignLabelWithHint: true,
                            hintStyle: TextStyle(color: Colors.grey.shade400)),
                      ),
                    )),
                    Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12)),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.link,
                          size: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                SizedBox(
                  child: Row(
                    children: [
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          if(_urlController!.text.isEmpty){
                            toast(context, 'Url can not empty');
                            return;
                          }
                          bloc!.downloadFile(_urlController!.text);
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(0, 0, 4, 8),
                          child: const Center(
                            child: Text(
                              'Download',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GalleryProvider(
                              child: GalleryView(),
                              bloc: GalleryBloc(),
                            ),
                          ));
                        },
                        child: Container(
                          margin: const EdgeInsets.fromLTRB(4, 0, 0, 8),
                          child: const Center(
                            child: Text(
                              'Gallery',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      )),
                    ],
                  ),
                  height: 48,
                )
              ],
            ),
          ),
          top: 60,
          right: 0,
          bottom: 0,
          left: 0,
        ),
        Positioned(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                      offset: const Offset(0, 3),
                      spreadRadius: 2,
                      blurRadius: 2,
                      color: Colors.grey.shade200)
                ],
                borderRadius: BorderRadius.circular(12)),
            child: Row(
              children: [
                Expanded(child: iconInsta()),
                Expanded(child: iconFb()),
                Expanded(child: iconSupport())
              ],
            ),
          ),
          top: 0,
          right: 28,
          left: 28,
          height: 100,
        ),
      ],
    );
  }

  private_media() {
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 4, 8, 4),
      margin: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Private media',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          Row(
            children: [
              const Expanded(
                  child: Text(
                'Download Private Instagram Media',
                style: TextStyle(color: Colors.black),
              )),
              Checkbox(
                  value: false,
                  onChanged: (v) {
                    toast(context, 'Updating');
                  })
            ],
          ),
          Row(
            children: [
              const Expanded(
                  child: Text(
                'Download Facebook Story',
                style: TextStyle(color: Colors.black),
              )),
              Checkbox(
                  value: false,
                  onChanged: (v) {
                    toast(context, 'Updating');
                  })
            ],
          ),
        ],
      ),
      height: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 3),
                color: Colors.grey.shade200,
                spreadRadius: 2,
                blurRadius: 2)
          ]),
    );
  }

  fb_stories() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          Row(
            children: [
              const Padding(
                  padding: EdgeInsets.fromLTRB(8, 0, 0, 0),
                  child: Text(
                    'Fb Stories',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  )),
              Expanded(
                  child: TextField(
                focusNode: _focusSearch,
                style: const TextStyle(
                    fontFamily: "SourceSerifPro",
                    color: Colors.black,
                    fontWeight: FontWeight.w400),
                onChanged: (value) {
                  //  loginHelper.checkEmail(value);
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(10),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.transparent),
                    ),
                    prefixIcon: GestureDetector(
                        child: const Icon(
                          Icons.search,
                          color: Colors.black,
                        ),
                        onTap: () {
                          _focusSearch!.requestFocus();
                        }),
                    suffixIcon: _focusSearch!.hasFocus
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            onPressed: () => disableFocus(),
                          )
                        : null),
              ))
            ],
          ),
          Expanded(
              child: Center(
            child: Image.asset(
              "assets/gif/gif_fb.gif",
              height: 80,
              width: 80,
            ),
          ))
        ],
      ),
      height: 160,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                offset: const Offset(0, 3),
                color: Colors.grey.shade200,
                spreadRadius: 2,
                blurRadius: 2)
          ]),
    );
  }
}
