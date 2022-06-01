import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:videodownloader/utils/ads_helper.dart';

class PrivacyPolicyView extends StatefulWidget {
  const PrivacyPolicyView({Key? key}) : super(key: key);

  @override
  State<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends State<PrivacyPolicyView> {
  BannerAd? _bottomBanner;
  InterstitialAd? _interstitialAd;
  bool _isBottomBannerLoaded = false;

  @override
  void initState() {
    super.initState();
   // initBottomBanner();
   // _createInterstitialAd();
  }

  void initBottomBanner() async {
    _bottomBanner = BannerAd(
        size: AdSize.banner,
        adUnitId: AdsHelper.bannerAdUtilId,
        listener: BannerAdListener(onAdLoaded: (ad) {
          setState(() {
            _isBottomBannerLoaded = false;
          });
        }, onAdFailedToLoad: (ad, err) {
          print(err);
          _bottomBanner!.dispose();
          _bottomBanner = null;
        }),
        request: const AdRequest());
    await _bottomBanner!.load();
  }

  void _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: AdsHelper.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
        },
        onAdFailedToLoad: (LoadAdError error) {
          _interstitialAd?.dispose();
          _interstitialAd = null;
          _createInterstitialAd();
        },
      ),
    );
  }

  autoHideButton() {
    Future.delayed(const Duration(milliseconds: 2000)).whenComplete(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _bottomBanner!.dispose();
    _interstitialAd!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Expanded(child: Text('Privacy')),
          GestureDetector(
            onTap: (){

            },
            child: Container(
              height: 60,
              decoration: const BoxDecoration(
                color: Colors.black
              ),
              child: const Center(
                child: Text(
                  'Agree & Next',
                  style: TextStyle(color: Colors.white,fontSize: 20),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
