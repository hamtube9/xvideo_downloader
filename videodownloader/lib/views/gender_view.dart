import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:videodownloader/main.dart';
import 'package:videodownloader/utils/ads_helper.dart';
import 'package:videodownloader/utils/constants.dart';
import 'package:videodownloader/views/category_view.dart';

enum Gender { male, female }

class GenderView extends StatefulWidget {
  const GenderView({Key? key}) : super(key: key);

  @override
  State<GenderView> createState() => _GenderViewState();
}

class _GenderViewState extends State<GenderView> {
  Gender gender = Gender.male;

  // BannerAd? _bottomBanner;
  // BannerAd? _headerBanner;
  // late AdManagerInterstitialAd _interstitialAd;
  // bool _isBottomBannerLoaded = false;
  // bool _isHeaderBannerLoaded = false;
  // bool _isLoadingAdLoaded = false;
  // bool _isNativeAdLoaded = false;
  // NativeAd? _nativeAd;

  @override
  void initState() {
    super.initState();
    FirebaseCrashlytics.instance.setCustomKey(keyScreen, 'Gender View');
    // Future.wait([
    //   initBottomBanner(),
    //   initLoadingAd(),
    //   initNativeAds(),
    // ]);
  }
  //
  // Future initNativeAds() async {
  //  try{
  //    _nativeAd =  NativeAd(adUnitId: AdsHelper.loadingOriginId,
  //        factoryId: 'listTile',
  //        listener: NativeAdListener(
  //            onAdLoaded: (ad) {
  //              setState(() {
  //                _isNativeAdLoaded = true;
  //              });
  //            },
  //            onAdFailedToLoad: (ad, err) async {
  //              await FirebaseCrashlytics.instance.recordError(
  //                  err,
  //                  StackTrace.current,
  //                  reason: 'load banner ad error',
  //                  fatal: true
  //              );
  //              print(err);
  //              ad.dispose();
  //            }
  //        ),
  //        request: const AdRequest());
  //    await _nativeAd!.load();
  //  }catch(e){
  //    FirebaseCrashlytics.instance.setCustomKey('Gender View',e.toString() );
  //
  //  }
  // }
  //
  // Future initLoadingAd() async {
  // try{
  //   await AdManagerInterstitialAd.load(
  //       adUnitId: AdsHelper.loadingAdUnitId,
  //       request: const AdManagerAdRequest(),
  //       adLoadCallback: AdManagerInterstitialAdLoadCallback(
  //         onAdLoaded: (AdManagerInterstitialAd ad) {
  //           print("AdManagerInterstitialAd loadeddddddddddddd");
  //           setState(() {
  //             _isLoadingAdLoaded = true;
  //             _interstitialAd = ad;
  //           });
  //           // Keep a reference to the ad so you can show it later.
  //         },
  //         onAdFailedToLoad: (LoadAdError error)async  {
  //           await FirebaseCrashlytics.instance.recordError(
  //               error,
  //               StackTrace.current,
  //               reason: 'load banner ad error',
  //               fatal: true
  //           );
  //           print('InterstitialAd failed to load: $error');
  //         },
  //
  //       ));
  // }catch(e){
  //   FirebaseCrashlytics.instance.setCustomKey('Gender View',e.toString() );
  // }
  // }
  // Future initBottomBanner() async {
  //  try{
  //    _bottomBanner = BannerAd(
  //        size: AdSize.banner,
  //        adUnitId: AdsHelper.bannerAdUtilId,
  //        listener: BannerAdListener(
  //          onAdLoaded: (ad) {
  //            print("loadedddddddddddddddd");
  //            setState(() {
  //              _isBottomBannerLoaded = true;
  //            });
  //          },
  //          onAdFailedToLoad: (ad, err) async  {
  //            print(err);
  //            await FirebaseCrashlytics.instance.recordError(
  //                err,
  //                StackTrace.current,
  //                reason: 'load banner ad error',
  //                fatal: true
  //            );
  //            _bottomBanner!.dispose();
  //            _bottomBanner = null;
  //          },
  //        ),
  //        request: const AdRequest());
  //    _headerBanner = BannerAd(
  //        size: AdSize.banner,
  //        adUnitId: AdsHelper.bannerAdUtilId,
  //        listener: BannerAdListener(
  //          onAdLoaded: (ad) {
  //            print("loadedddddddddddddddd");
  //            setState(() {
  //              _isHeaderBannerLoaded = true;
  //            });
  //          },
  //          onAdFailedToLoad: (ad, err)  async {
  //            await FirebaseCrashlytics.instance.recordError(
  //                err,
  //                StackTrace.current,
  //                reason: 'load banner ad error',
  //                fatal: true
  //            );
  //            print(err);
  //            _headerBanner!.dispose();
  //            _headerBanner = null;
  //          },
  //        ),
  //        request: const AdRequest());
  //    await _bottomBanner!.load();
  //    await _headerBanner!.load();
  //  }catch(e){
  //    FirebaseCrashlytics.instance.setCustomKey('Gender View',e.toString() );
  //
  //  }
  // }
  //
  // void _createInterstitialAd() async {
  //   if(_isLoadingAdLoaded == false){
  //     print("wait");
  //     return;
  //   }
  //   _interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
  //     onAdShowedFullScreenContent: (AdManagerInterstitialAd ad) =>
  //         print('%ad onAdShowedFullScreenContent.'),
  //     onAdDismissedFullScreenContent: (AdManagerInterstitialAd ad) {
  //       print('$ad onAdDismissedFullScreenContent.');
  //       showLoading();
  //       ad.dispose().then((value) {
  //         hideLoading();
  //         navigation();
  //       });
  //     },
  //     onAdFailedToShowFullScreenContent: (AdManagerInterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //     },
  //     onAdImpression: (AdManagerInterstitialAd ad) => print('$ad impression occurred.'),
  //   );
  //   await _interstitialAd.show();
  //
  // }


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    // _bottomBanner?.dispose();
    // _headerBanner?.dispose();
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
                // _isNativeAdLoaded ? Container(
                //   height: 120,
                //   alignment: Alignment.center,
                //   child: AdWidget(ad: _nativeAd!,),
                // ) : Container(),
                buttonContinue(),
              ],
            ),
            // top: _isHeaderBannerLoaded ? _headerBanner!.size.height.toDouble() : 0,
            top: 0,
            right: 0,
            left: 0,
            bottom: 0,
          ),
          // Positioned(
          //   child: _isHeaderBannerLoaded
          //       ? Container(
          //           child: AdWidget(ad: _headerBanner!),
          //           width: _headerBanner!.size.width.toDouble(),
          //           height: _headerBanner!.size.height.toDouble(),
          //           alignment: Alignment.center,
          //         )
          //       : Container(),
          //   top: 0,
          //   right: 0,
          //   left: 0,
          //   height: _isHeaderBannerLoaded ? _headerBanner!.size.height.toDouble() : 0,
          // )
        ],
      ),
      // bottomNavigationBar: _isBottomBannerLoaded
      //     ? Container(
      //         child: AdWidget(ad: _bottomBanner!),
      //         width: _bottomBanner!.size.width.toDouble(),
      //         height: _bottomBanner!.size.height.toDouble(),
      //         alignment: Alignment.center,
      //       )
      //     : SizedBox(height: 0,width: 0,),
    );
  }

  buttonContinue() {
    return GestureDetector(
      onTap: () {
        // _createInterstitialAd();
navigation();
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
