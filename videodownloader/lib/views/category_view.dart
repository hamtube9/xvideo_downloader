import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:videodownloader/main.dart';
import 'package:videodownloader/model/category/category.dart';
import 'package:videodownloader/utils/ads_helper.dart';
import 'package:videodownloader/utils/constants.dart';
import 'package:videodownloader/views/button_animation_color.dart';
import 'package:videodownloader/views/language_view.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
  AdManagerBannerAd? _bottomBanner;
  AdManagerBannerAd? _headerBanner;
  AdManagerInterstitialAd? _interstitialAd;
  bool _isBottomBannerLoaded = false;
  bool _isHeaderBannerLoaded = false;
  bool _isLoadingAdLoaded = false;

  @override
  void initState() {
    super.initState();
    FirebaseCrashlytics.instance.setCustomKey(keyScreen, 'Category View');
    Future.wait([initBottomBanner(), initLoadingAd()]);
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
                _isLoadingAdLoaded = true;
                _interstitialAd = null;
              });
              await FirebaseCrashlytics.instance.recordError(error, StackTrace.current,
                  reason: 'load banner ad error', fatal: true);
              print('InterstitialAd failed to load: $error');
            },
          ));
    } catch (e) {
      setState(() {
        _isLoadingAdLoaded = true;
        _interstitialAd = null;
      });
      FirebaseCrashlytics.instance.setCustomKey('Category View', e.toString());
    }
  }

  Future initBottomBanner() async {
    try {
      _bottomBanner = AdManagerBannerAd(
        sizes: [AdSize.banner],
        request: const AdManagerAdRequest(),
        adUnitId: AdsHelper.bannerAdUtilId,
        listener: AdManagerBannerAdListener(
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
            await FirebaseCrashlytics.instance
                .recordError(err, StackTrace.current, reason: 'load banner ad error', fatal: true);
          },
        ),
      );
      _headerBanner = AdManagerBannerAd(
        sizes: [AdSize.banner],
        request: const AdManagerAdRequest(),
        adUnitId: AdsHelper.bannerAdUtilId,
        listener: AdManagerBannerAdListener(
          onAdLoaded: (ad) {
            print("loadedddddddddddddddd");
            setState(() {
              _isHeaderBannerLoaded = true;
            });
            hideLoading();
          },
          onAdFailedToLoad: (ad, err) async {
            print(err);
            setState(() {
              _isHeaderBannerLoaded = false;
              _headerBanner = null;
            });
            hideLoading();
            await FirebaseCrashlytics.instance
                .recordError(err, StackTrace.current, reason: 'load banner ad error', fatal: true);
          },
        ),
      );
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
      hideLoading();
    }
  }

  Future _createInterstitialAd() async {
    if (_interstitialAd == null && _isLoadingAdLoaded == true) {
      navigation();
    } else {
      if (_isLoadingAdLoaded == false) {
        showLoading();
        return;
      }
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
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
      await _interstitialAd!.show();
    }
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
    var listCategories = categories;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Select your favorite websites topics'),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Wrap(
                      spacing: 24,
                      direction: Axis.horizontal,
                      alignment: WrapAlignment.center,
                      children: [
                        if (listCategories.isNotEmpty)
                          for (int i = 0; i < listCategories.length; i++)
                            ChangeRaisedButtonColor(
                              text: listCategories[i].name!,
                              onClick: (v) {
                                selectAnswer(listCategories[i]);
                              },
                              isSelected: listCategories[i].isSelected,
                            )
                      ]),
                ),
                buttonContinue()
              ],
            ),
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          Positioned(
            child: _isHeaderBannerLoaded && _headerBanner != null
                ? Container(
                    child: AdWidget(
                      ad: _headerBanner!,
                    ),
                    height: _headerBanner!.sizes.first.height.toDouble(),
                    width: _headerBanner!.sizes.first.width.toDouble(),
                    alignment: Alignment.center,
                  )
                : const SizedBox(
                    height: 0,
                    width: 0,
                  ),
            top: 0,
            right: 0,
            left: 0,
            height: _isHeaderBannerLoaded ? _headerBanner!.sizes.first.height.toDouble() : 0,
          )
        ],
      ),
      bottomNavigationBar: _isBottomBannerLoaded && _bottomBanner != null
          ? Container(
              child: AdWidget(
                ad: _bottomBanner!,
              ),
              height: _bottomBanner!.sizes.first.height.toDouble(),
              width: _bottomBanner!.sizes.first.width.toDouble(),
              alignment: Alignment.center,
            )
          : const SizedBox(
              height: 0,
              width: 0,
            ),
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

  void selectAnswer(Category cat) {
    setState(() {
      cat.isSelected = !cat.isSelected;
    });
  }

  void navigation() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
      builder: (context) => const LanguageView(),
    ));
  }
}
