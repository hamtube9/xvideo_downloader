import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:videodownloader/bloc/gallery_bloc.dart';
import 'package:videodownloader/bloc/gallery_provider.dart';
import 'package:videodownloader/utils/ads_helper.dart';
import 'package:videodownloader/utils/compare.dart';
import 'package:videodownloader/views/play_media_view.dart';
import 'package:videodownloader/views/tabbar_gallery_view.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView> with SingleTickerProviderStateMixin {
  GalleryBloc? bloc;

  BannerAd? _bottomBanner;
  bool _isBottomBannerLoaded = false;

  void initBottomBanner() async {
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
          onAdFailedToLoad: (ad, err) {
            print(err);
            _bottomBanner!.dispose();
            _bottomBanner = null;
          },
        ),
        request: const AdRequest());
    await _bottomBanner!.load();
  }

  @override
  void initState() {
    super.initState();
    bloc = GalleryProvider.of(context);
    bloc!.loadFiles();
    initBottomBanner();
  }

  @override
  Widget build(BuildContext context) {
    double itemHeight = (MediaQuery.of(context).size.height - kToolbarHeight - 24) / 4;
    double itemWidth = MediaQuery.of(context).size.width / 4;
    return Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              TabbarGalleryView(
                onChangeTab: (v) {
                  bloc!.onChangeList(v);
                },
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: ValueListenableBuilder<List<FileSystemEntity>?>(
                  builder: (context, value, child) {
                    if (value != null && value.isNotEmpty) {
                      return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              crossAxisSpacing: 8,
                              mainAxisSpacing: 8,
                              childAspectRatio: (itemWidth / itemHeight)),
                          itemCount: value.length,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int i) {
                            return GestureDetector(
                              child: item(value[i]),
                              onTap: () => selectItem(value[i]),
                            );
                          });
                    }
                    return Container();
                  },
                  valueListenable: bloc!.notifierFiles,
                ),
              ))
            ],
          ),
        ),
        bottomNavigationBar: _isBottomBannerLoaded
            ? Container(
                child: AdWidget(
                  ad: _bottomBanner!,
                ),
                height: _bottomBanner!.size.height.toDouble(),
                width: _bottomBanner!.size.width.toDouble(),
                alignment: Alignment.center,
              )
            : Container());
  }

  item(FileSystemEntity item) {
    if (checkConstainsString(item.path, ['mp4', 'mov'])) {
      return FutureBuilder<Uint8List>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return videoItem(snapshot.data);
          }
          return Container();
        },
        future: getVideoPath(item.path),
      );
    } else if (checkConstainsString(item.path, ['m4a', 'mp3', 'ogg', 'wav'])) {
      return audioItem(item);
    } else if (checkConstainsString(item.path, ['png', 'jpeg', 'jpg'])) {
      return imageItem(item);
    }

    return Text(item.path);
  }

  Future<Uint8List> getVideoPath(String path) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );

    return uint8list!;
  }

  videoItem(Uint8List? data) {
    return SizedBox(
        height: 120,
        width: 80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              Positioned(
                child: Image.memory(
                  data!,
                  fit: BoxFit.fill,
                ),
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
              ),
              const Positioned(
                child: Icon(
                  Icons.play_circle_outline,
                  color: Colors.grey,
                  size: 40,
                ),
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
              ),
            ],
          ),
        ));
  }

  imageItem(FileSystemEntity item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              color: Colors.grey.shade200,
            ),
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
          ),
          Positioned(
            child: Image.file(File(item.path)),
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
          ),
        ],
      ),
    );
  }

  audioItem(FileSystemEntity item) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              color: Colors.grey.shade200,
            ),
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
          ),
          Positioned(
            child: Image.asset('assets/images/audiofile.png'),
            top: 0,
            right: 0,
            bottom: 0,
            left: 0,
          ),
        ],
      ),
    );
  }

  selectItem(FileSystemEntity item) {
    showDialog(
        context: context, builder: (context) => PlayMediaView(path: item.path), useSafeArea: false);
  }
}
