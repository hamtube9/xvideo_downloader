import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:videodownloader/utils/ads_helper.dart';

enum Gender { male, female }

class GenderView extends StatefulWidget {
  const GenderView({Key? key}) : super(key: key);

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  Gender gender = Gender.male;

  BannerAd? _bottomBanner;
  InterstitialAd? _interstitialAd;
  bool _isBottomBannerLoaded = false;

  @override
  void initState() {
    super.initState();
  //  initBottomBanner();
    //_createInterstitialAd();
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Select your gender for better experience'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 120,
                child: Column(
                  children: [
                    Image.asset('assets/images/man.jpg'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                            value: Gender.male,
                            groupValue: gender,
                            onChanged: (v) {
                              setState(() {
                                gender = Gender.male;
                              });
                            }),
                        const Text(
                          'Male',
                          style: TextStyle(),
                        )
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              SizedBox(
                width: 120,
                child: Column(
                  children: [
                    Image.asset('assets/images/woman.jpg'),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Radio(
                            value: Gender.female,
                            groupValue: gender,
                            onChanged: (v) {
                              setState(() {
                                gender = Gender.female;
                              });
                            }),
                        const Text(
                          'Female',
                          style: TextStyle(),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
         buttonContinue()
        ],
      ),
    );
  }

  buttonContinue() {
    return  GestureDetector(
      onTap: (){

      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.all(16),
        height: 60,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), color: Colors.black),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Continue',
              style: TextStyle(color: Colors.white, fontSize: 20,fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 4,),
            Icon(
              Icons.arrow_forward_outlined,
              color: Colors.white,
              size: 28,
            )
          ],
        ),
      ),
    );
  }
}
