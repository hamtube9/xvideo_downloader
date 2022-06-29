import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:videodownloader/main.dart';
import 'package:videodownloader/utils/ads_helper.dart';
import 'package:videodownloader/utils/constants.dart';
import 'package:videodownloader/views/warning_view.dart';
import 'package:videodownloader/views/web_view.dart';

class IntroduceView extends StatefulWidget {
  const IntroduceView({Key? key}) : super(key: key);

  @override
  State<IntroduceView> createState() => _IntroduceViewState();
}

class _IntroduceViewState extends State<IntroduceView> {
  BannerAd? _bottomBanner;
  BannerAd? _headerBanner;
  AdManagerInterstitialAd? _interstitialAd;
  bool _isBottomBannerLoaded = false;
  bool _isHeaderBannerLoaded = false;
  bool _isNativeAdLoaded = false;
  bool _isLoadingAdLoaded = false;

  NativeAd? _nativeAd;

  @override
  void initState() {
    super.initState();
    FirebaseCrashlytics.instance.setCustomKey(keyScreen, 'Introduce View');
    Future.wait([
      initBottomBanner(),
      initLoadingAd(),
      initNativeAds(),
    ]);
  }

  Future initNativeAds() async {
    try {
      _nativeAd = NativeAd(
          adUnitId: AdsHelper.loadingOriginId,
          factoryId: 'listTile',
          listener: NativeAdListener(onAdLoaded: (ad) {
            setState(() {
              _isNativeAdLoaded = true;
            });
          }, onAdFailedToLoad: (ad, err) async {
            print(err);
            setState(() {
              _isNativeAdLoaded = false;
              _nativeAd = null;
            });
            ad.dispose();
            await FirebaseCrashlytics.instance
                .recordError(err, StackTrace.current, reason: 'load native ad  error', fatal: true);
          }),
          request: const AdRequest());
      await _nativeAd!.load();
    } catch (e) {
      FirebaseCrashlytics.instance.setCustomKey('Introduce View', e.toString());
    }
  }

  Future initLoadingAd() async {
    try {
      await AdManagerInterstitialAd.load(
          adUnitId: AdsHelper.loadingAdUnitId,
          request: const AdManagerAdRequest(),
          adLoadCallback: AdManagerInterstitialAdLoadCallback(
            onAdLoaded: (AdManagerInterstitialAd ad) {
              print("AdManagerInterstitialAd loadeddddddddddddd");
              setState(() {
                _isLoadingAdLoaded = true;
                _interstitialAd = ad;
              });
              // Keep a reference to the ad so you can show it later.
            },
            onAdFailedToLoad: (LoadAdError error) async {
              setState(() {
                _isLoadingAdLoaded = false;
                _interstitialAd = null;
              });
              print('InterstitialAd failed to load: $error');
              await FirebaseCrashlytics.instance
                  .recordError(error, StackTrace.current, reason: 'load ad error', fatal: true);
            },
          ));
    } catch (e) {
      setState(() {
        _isLoadingAdLoaded = false;
        _interstitialAd = null;
      });
      FirebaseCrashlytics.instance.setCustomKey('Introduce View', e.toString());
    }
  }

  Future initBottomBanner() async {
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
              print(err);
              setState(() {
                _isBottomBannerLoaded = false;
                _bottomBanner = null;
              });
              await FirebaseCrashlytics.instance.recordError(err, StackTrace.current,
                  reason: 'load banner ad error', fatal: true);
            },
          ),
          request: const AdRequest());
      _headerBanner = BannerAd(
          size: AdSize.banner,
          adUnitId: AdsHelper.bannerAdUtilId2,
          listener: BannerAdListener(
            onAdLoaded: (ad) {
              print("loadedddddddddddddddd");
              setState(() {
                _isHeaderBannerLoaded = true;
              });
            },
            onAdFailedToLoad: (ad, err) async {
              setState(() {
                _isHeaderBannerLoaded = false;
                _headerBanner = null;
              });
              print(err);
              await FirebaseCrashlytics.instance.recordError(err, StackTrace.current,
                  reason: 'load banner ad error', fatal: true);
            },
          ),
          request: const AdRequest());
      await _bottomBanner!.load();
      await _headerBanner!.load();
    } catch (e) {
      FirebaseCrashlytics.instance.setCustomKey('Introduce View', e.toString());
      setState(() {
        _isBottomBannerLoaded = false;
        _bottomBanner = null;
        _isHeaderBannerLoaded = false;
        _headerBanner = null;
      });
    }
  }

  void _createInterstitialAd() async {
    if(_interstitialAd == null){
      navigation();
    }
    else{
      if (_isLoadingAdLoaded == false) {
        print("wait");
        return;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdShowedFullScreenContent: (AdManagerInterstitialAd ad) =>
            print('%ad onAdShowedFullScreenContent.'),
        onAdDismissedFullScreenContent: (AdManagerInterstitialAd ad) {
          print('$ad onAdDismissedFullScreenContent.');
          showLoading();
          ad.dispose().then((value) {
            navigation();
            hideLoading();
          });
        },
        onAdFailedToShowFullScreenContent: (AdManagerInterstitialAd ad, AdError error) {
          print('$ad onAdFailedToShowFullScreenContent: $error');
          ad.dispose();
        },
        onAdImpression: (AdManagerInterstitialAd ad) => print('$ad impression occurred.'),
      );
      await _interstitialAd!.show();
    }

  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bottomBanner?.dispose();
    _headerBanner?.dispose();
    _nativeAd?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          child: Stack(
            children: [
              Positioned(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Center(
                          child: _icon(Icons.star_rounded, "Rate App", () => _openStore()),
                        )),
                        Expanded(
                            child: Center(
                          child: _icon(Icons.share, "Share App", () => _shareApp()),
                        )),
                        Expanded(
                            child: Center(
                          child: _icon(Icons.shield, "Privacy Policy", () => _privacyPolicy()),
                        )),
                      ],
                    ),
                    _isNativeAdLoaded && _nativeAd != null
                        ? Container(
                            height: 120,
                            alignment: Alignment.center,
                            child: AdWidget(
                              ad: _nativeAd!,
                            ),
                          )
                        : const SizedBox(height: 0,width: 0,),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.green.shade400),
                        onPressed: () {
                          _createInterstitialAd();
                        },
                        child: const Text(
                          "Let's Start",
                          style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
                top: 0,
                right: 0,
                left: 0,
                bottom: 0,
              ),
              Positioned(
                child: _isHeaderBannerLoaded &&  _headerBanner != null
                    ? Container(
                        margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                        child: AdWidget(
                          ad: _headerBanner!,
                        ),
                        height: _headerBanner!.size.height.toDouble(),
                        width: _headerBanner!.size.width.toDouble(),
                      )
                    : const SizedBox(height: 0,width: 0,),
                top: 0,
                right: 0,
                left: 0,
              ),
            ],
          ),
          padding: const EdgeInsets.all(16)),
      bottomNavigationBar: _isBottomBannerLoaded &&  _bottomBanner != null
          ? SizedBox(
              child: AdWidget(ad: _bottomBanner!),
              height: _bottomBanner!.size.height.toDouble(),
              width: _bottomBanner!.size.width.toDouble(),
            )
          : const SizedBox(height: 0,width: 0),
    );
  }

  _icon(IconData ic, String text, Function onClick) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => onClick(),
          child: Container(
            height: 40,
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 8),
            width: 40,
            alignment: Alignment.center,
            child: Icon(
              ic,
              color: Colors.green,
            ),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    blurRadius: 1,
                  )
                ]),
          ),
        ),
        Text(text)
      ],
    );
  }

  _openStore() async {
    try {
      await StoreRedirect.redirect(androidAppId: "ngaoschos.videodownloader");
    } catch (e) {
      print(e);
    }
  }

  void navigation() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const WarningView(),
    ));
  }

  _shareApp() async {
    String link = "https://play.google.com/store/apps/details?id=ngaoschos.videodownloader";
    await Share.share(link, subject: "App Download Xvideo");
  }

  _privacyPolicy() async {
    String link =
        "https://www.app-privacy-policy.com/live.php?token=4zlF44y6BinaPaV6ncpdUSTupTz6MJ4h";
    await Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => Webview(url: link),
    ));
  }
}
