import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:videodownloader/main.dart';
import 'package:videodownloader/utils/ads_helper.dart';
import 'package:videodownloader/views/gender_view.dart';
import 'package:videodownloader/views/web_view.dart';

class WarningView extends StatefulWidget {
  const WarningView({Key? key}) : super(key: key);

  @override
  State<WarningView> createState() => _WarningViewState();
}

class _WarningViewState extends State<WarningView> {
  BannerAd? _bottomBanner;
  BannerAd? _headerBanner;
  late AdManagerInterstitialAd _interstitialAd;
  bool _isBottomBannerLoaded = false;
  bool _isHeaderBannerLoaded = false;
  bool _isLoadingAdLoaded = false;

  @override
  void initState() {
    super.initState();
    initBottomBanner();
    initLoadingAd();
  }

  void initLoadingAd() async {
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
          onAdFailedToLoad: (LoadAdError error) {
            print('InterstitialAd failed to load: $error');
          },
        ));
  }

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
    _headerBanner = BannerAd(
        size: AdSize.banner,
        adUnitId: AdsHelper.bannerAdUtilId,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            print("loadedddddddddddddddd");
            setState(() {
              _isHeaderBannerLoaded = true;
            });
          },
          onAdFailedToLoad: (ad, err) {
            print(err);
            _headerBanner!.dispose();
            _headerBanner = null;
          },
        ),
        request: const AdRequest());
    await _bottomBanner!.load();
    await _headerBanner!.load();
  }

  void _createInterstitialAd() async {
    if (_isLoadingAdLoaded == false) {
      print("wait");
      return;
    }
    _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
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
      onAdFailedToShowFullScreenContent:
          (AdManagerInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (AdManagerInterstitialAd ad) =>
          print('$ad impression occurred.'),
    );
    await _interstitialAd.show();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bottomBanner?.dispose();
    _headerBanner?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.white, borderRadius: BorderRadius.circular(8),
                    boxShadow: [BoxShadow(offset: Offset(0,0),spreadRadius: 1,blurRadius: 1)]),
                child: const Icon(
                  Icons.computer,
                  color: Colors.purple,
                ),
                alignment: Alignment.center,
              ),),
              Container(
                margin: const EdgeInsets.all(8),
                padding: const EdgeInsets.all(8),
                child: const Text(
                    "The video you're downloading might be too large. Make sure you have enough memory on your phone before download any video.\n \nFor better experience, it is recommended that you download video via wifi network, since downloading from data network will cost you more money. ",style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Row(
                children: [
                  Expanded(
                      child: Center(
                        child: _icon(
                            Icons.star_rounded, "Rate App", () => _openStore()),
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
              _isHeaderBannerLoaded
                  ? Container(
                margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
                child: AdWidget(
                  ad: _headerBanner!,
                ),
                height: _headerBanner!.size.height.toDouble(),
                width: _headerBanner!.size.width.toDouble(),
              )
                  : Container(),
              ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(primary: Colors.green.shade400),
                  onPressed: () {},
                  child: const Text(
                    'Đăng ký ngay',
                    style: TextStyle(color: Colors.white),
                  )),
              ElevatedButton(
                  style:
                  ElevatedButton.styleFrom(primary: Colors.green.shade400),
                  onPressed: () {
                    _createInterstitialAd();
                  },
                  child: const Text(
                    "Let's Start",
                    style: TextStyle(color: Colors.black),
                  )),
            ],
          ),
          padding: const EdgeInsets.all(16)),
      bottomNavigationBar: _isBottomBannerLoaded
          ? SizedBox(
        child: AdWidget(ad: _bottomBanner!),
        height: _bottomBanner!.size.height.toDouble(),
        width: _bottomBanner!.size.width.toDouble(),
      )
          : Container(),
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
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const GenderView(),));
  }

  _shareApp()  async {
    String link =  "https://play.google.com/store/apps/details?id=ngaoschos.videodownloader";
    await Share.share(link,subject: "App Download Xvideo");
  }

  _privacyPolicy() async {
    String link = "https://www.app-privacy-policy.com/live.php?token=4zlF44y6BinaPaV6ncpdUSTupTz6MJ4h";
    await Navigator.of(context).push(MaterialPageRoute(builder: (context) => Webview(url: link),));
  }
}
