import 'package:clipboard/clipboard.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:videodownloader/bloc/gallery_bloc.dart';
import 'package:videodownloader/bloc/gallery_provider.dart';
import 'package:videodownloader/bloc/main_bloc.dart';
import 'package:videodownloader/bloc/main_provider.dart';
import 'package:videodownloader/main.dart';
import 'package:videodownloader/utils/ads_helper.dart';
import 'package:videodownloader/utils/constants.dart';
import 'package:videodownloader/views/gallery_view.dart';

class DownloadView extends StatefulWidget {
  const DownloadView({Key? key}) : super(key: key);

  @override
  State<DownloadView> createState() => _DownloadViewState();
}

class _DownloadViewState extends State<DownloadView> {
  bool downloading = false;
  var progressString = "";
  bool isShowButton = false;
  bool isPlaying = false;
  PermissionStatus status = PermissionStatus.denied;

  FocusNode? _focusSearch;
  TextEditingController? _searchController;
  TextEditingController? _urlController;
  MainBloc? bloc;

  BannerAd? _bottomBanner;
  bool _isBottomBannerLoaded = false;

  @override
  void initState() {
    super.initState();
    FirebaseCrashlytics.instance.setCustomKey(keyScreen, 'Main Download View');
    bloc = MainProvider.of(context);
    _focusSearch = FocusNode();
    _searchController = TextEditingController();
    _urlController = TextEditingController();
    // permission();
    initBottomBanner();
  }

  void initBottomBanner() async {
    try {
      _bottomBanner = BannerAd(
          size: AdSize.banner,
          adUnitId: AdsHelper.bannerAdUtilId,
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              print("loadedddddddddddddddd");
              setState(() {
                _isBottomBannerLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, err) async {
              setState(() {
                _isBottomBannerLoaded = false;
                _bottomBanner = null;
              });
              print(err);
              await FirebaseCrashlytics.instance.recordError(err, StackTrace.current,
                  reason: 'load banner ad error', fatal: true);
            },
          ),
          request: const AdRequest());

      await _bottomBanner!.load();
    } catch (e) {
      setState(() {
        _isBottomBannerLoaded = false;
        _bottomBanner = null;
      });
      FirebaseCrashlytics.instance.setCustomKey('Main Download View', e.toString());
    }
  }

  autoHideButton() {
    Future.delayed(const Duration(milliseconds: 2000)).whenComplete(() {
      setState(() {
        isShowButton = false;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _focusSearch?.dispose();
    _searchController?.dispose();
    _urlController?.dispose();
    _bottomBanner?.dispose();

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
              height: height * 0.58,
              child: Stack(
                children: [
                  Positioned(
                    child: backgroundBlack(),
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
            ValueListenableBuilder<int>(
              valueListenable: bloc!.notifierTime,
              builder: (BuildContext context, value, Widget? child) {
                return value > 0
                    ? Container(
                        child: Text(
                          "Wait $value s for next download",
                          style: const TextStyle(color: Colors.green),
                        ),
                        alignment: Alignment.center,
                      )
                    : Container();
              },
            ),
            ValueListenableBuilder<String>(
              valueListenable: bloc!.notifierError,
              builder: (BuildContext context, String value, Widget? child) {
                return value.isNotEmpty
                    ? Container(
                        child: Text(
                          value,
                          style: const TextStyle(color: Colors.red),
                        ),
                        alignment: Alignment.center,
                      )
                    : Container();
              },
            ),
            privateMedia(),
            fbStories(),
            _isBottomBannerLoaded && _bottomBanner != null
                ? Container(
                    child: AdWidget(
                      ad: _bottomBanner!,
                    ),
                    height: _bottomBanner!.size.height.toDouble(),
                    width: _bottomBanner!.size.width.toDouble(),
                    alignment: Alignment.center,
                  )
                : const SizedBox(height: 0 ,width: 0,)
          ],
        ),
      ),
    );
  }

  disableFocus() {
    SystemChannels.textInput.invokeListMethod("TextInput.hide");
    _focusSearch!.unfocus();
  }

  iconSupport() {
    return Column(
      children: [
        Container(
          child: const Center(
            child: Icon(
              Icons.more_horiz,
              color: Colors.white,
              size: 24,
            ),
          ),
          decoration:
              BoxDecoration(color: Colors.deepPurple, borderRadius: BorderRadius.circular(16)),
          height: 40,
          width: 40,
        ),
        const Text(
          'Support',
          style: TextStyle(color: Colors.black),
        )
      ],
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
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
            style: TextStyle(color: Colors.black),
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
                              topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
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
                    GestureDetector(
                      onTap: () async {
                        var text = await FlutterClipboard.paste();
                        setState(() {
                          _urlController!.text = text;
                          // _urlController!.text = "https://www.xvideos.com/video35033155/beautiful_japanesegirl_-_nanairo.co";
                        });
                      },
                      child: Container(
                        height: 48,
                        width: 48,
                        decoration: const BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12), bottomRight: Radius.circular(12)),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.link,
                            size: 24,
                            color: Colors.white,
                          ),
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
                          if (_urlController!.text.isEmpty) {
                            toast(context, 'Url can not empty');
                            return;
                          }
                          if (bloc!.notifierTime.value > 0) {
                            toast(context, 'Wait ${bloc!.notifierTime.value}s for next download');
                            return;
                          }
                          bloc!.getUrlDownload(_urlController!.text);
                          _urlController!.clear();
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
                              color: Colors.black, borderRadius: BorderRadius.circular(8)),
                        ),
                      )),
                      Expanded(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => GalleryProvider(
                              child: const GalleryView(),
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
                              color: Colors.black, borderRadius: BorderRadius.circular(8)),
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

  privateMedia() {
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

  fbStories() {
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
                    fontFamily: "SourceSerifPro", color: Colors.black, fontWeight: FontWeight.w400),
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

  backgroundBlack() {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius:
              BorderRadius.only(bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60))),
    );
  }
}
