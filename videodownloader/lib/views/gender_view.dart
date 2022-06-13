import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:videodownloader/main.dart';
import 'package:videodownloader/utils/ads_helper.dart';
import 'package:videodownloader/views/category_view.dart';

enum Gender { male, female }

class GenderView extends StatefulWidget {
  const GenderView({Key? key}) : super(key: key);

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  Gender gender = Gender.male;

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
    if(_isLoadingAdLoaded == false){
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
          hideLoading();
          navigation();
        });
      },
      onAdFailedToShowFullScreenContent: (AdManagerInterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
      },
      onAdImpression: (AdManagerInterstitialAd ad) => print('$ad impression occurred.'),
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
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned(
            child: Column(
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
                buttonContinue(),
              ],
            ),
            top: _isHeaderBannerLoaded ? _headerBanner!.size.height.toDouble() : 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          Positioned(
            child: _isHeaderBannerLoaded
                ? Container(
                    child: AdWidget(ad: _headerBanner!),
                    width: _headerBanner!.size.width.toDouble(),
                    height: _headerBanner!.size.height.toDouble(),
                    alignment: Alignment.center,
                  )
                : Container(),
            top: 0,
            right: 0,
            left: 0,
            height: _isHeaderBannerLoaded ? _headerBanner!.size.height.toDouble() : 0,
          )
        ],
      ),
      bottomNavigationBar: _isBottomBannerLoaded
          ? Container(
              child: AdWidget(ad: _bottomBanner!),
              width: _bottomBanner!.size.width.toDouble(),
              height: _bottomBanner!.size.height.toDouble(),
              alignment: Alignment.center,
            )
          : Container(),
    );
  }

  buttonContinue() {
    return GestureDetector(
      onTap: () {
        _createInterstitialAd();

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
              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              width: 4,
            ),
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

  void navigation() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const CategoryView(),
    ));
  }
}
