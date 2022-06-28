import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:share/share.dart';
import 'package:store_redirect/store_redirect.dart';
import 'package:videodownloader/main.dart';
import 'package:videodownloader/utils/ads_helper.dart';
import 'package:videodownloader/utils/constants.dart';
import 'package:videodownloader/views/gender_view.dart';
import 'package:videodownloader/views/web_view.dart';

class WarningView extends StatefulWidget {
  const WarningView({Key? key}) : super(key: key);

  @override
  State<WarningView> createState() => _WarningViewState();
}

class _WarningViewState extends State<WarningView> {
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
    FirebaseCrashlytics.instance.setCustomKey(keyScreen, 'Warning View');

    // Future.wait([
    //   initBottomBanner(),
    //   initLoadingAd(),
    //   initNativeAds(),
    // ]);
  }

  //
  // Future initNativeAds() async {
  //   try{
  //     _nativeAd =  NativeAd(adUnitId: AdsHelper.loadingOriginId,
  //         factoryId: 'listTile',
  //         listener: NativeAdListener(
  //             onAdLoaded: (ad) {
  //               setState(() {
  //                 _isNativeAdLoaded = true;
  //               });
  //             },
  //             onAdFailedToLoad: (ad, err) async {
  //               print(err);
  //               ad.dispose();
  //               await FirebaseCrashlytics.instance.recordError(
  //                   err,
  //                   StackTrace.current,
  //                   reason: 'load native ad error',
  //                   fatal: true
  //               );
  //             }
  //         ),
  //         request: const AdRequest());
  //     await _nativeAd!.load();
  //   }catch(e){
  //     FirebaseCrashlytics.instance.setCustomKey('Warning View', e.toString());
  //   }
  //
  // }
  //
  //
  // Future initLoadingAd() async {
  //   try{
  //     await AdManagerInterstitialAd.load(
  //         adUnitId: AdsHelper.loadingAdUnitId,
  //         request: const AdManagerAdRequest(),
  //         adLoadCallback: AdManagerInterstitialAdLoadCallback(
  //           onAdLoaded: (AdManagerInterstitialAd ad) {
  //             print("AdManagerInterstitialAd loadeddddddddddddd");
  //             setState(() {
  //               _isLoadingAdLoaded = true;
  //               _interstitialAd = ad;
  //             });
  //             // Keep a reference to the ad so you can show it later.
  //           },
  //           onAdFailedToLoad: (LoadAdError error) async  {
  //             await FirebaseCrashlytics.instance.recordError(
  //                 error,
  //                 StackTrace.current,
  //                 reason: 'load banner ad error',
  //                 fatal: true
  //             );
  //             print('InterstitialAd failed to load: $error');
  //
  //           },
  //         ));
  //   }catch(e){
  //     FirebaseCrashlytics.instance.setCustomKey('Warning View', e.toString());
  //   }
  //
  // }
  //
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
  //
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
  //          onAdFailedToLoad: (ad, err) {
  //            print(err);
  //            _headerBanner!.dispose();
  //            _headerBanner = null;
  //          },
  //        ),
  //        request: const AdRequest());
  //    await _bottomBanner!.load();
  //    await _headerBanner!.load();
  //  }catch(e){
  //    FirebaseCrashlytics.instance.setCustomKey('Warning View', e.toString());
  //  }
  // }
  //
  // void _createInterstitialAd() async {
  //   if (_isLoadingAdLoaded == false) {
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
  //         navigation();
  //         hideLoading();
  //       });
  //     },
  //     onAdFailedToShowFullScreenContent:
  //         (AdManagerInterstitialAd ad, AdError error) {
  //       print('$ad onAdFailedToShowFullScreenContent: $error');
  //       ad.dispose();
  //     },
  //     onAdImpression: (AdManagerInterstitialAd ad) =>
  //         print('$ad impression occurred.'),
  //   );
  //   await _interstitialAd.show();
  // }
  //
  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   super.dispose();
  //   _bottomBanner?.dispose();
  //   _headerBanner?.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
          child:
          Stack(children: [
            Positioned(child:  Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [

                Center(child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(8),
                      boxShadow: const [BoxShadow(offset: Offset(0,0),spreadRadius: 1,blurRadius: 1)]),
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
                          child: _icon(
                              Icons.share, "Share App", () => _shareApp()),
                        )),
                    Expanded(
                        child: Center(
                          child: _icon(
                              Icons.shield, "Privacy Policy", () =>
                              _privacyPolicy()),
                        )),
                  ],
                ),
                // _isNativeAdLoaded ? Container(
                //   height: 120,
                //   alignment: Alignment.center,
                //   child: AdWidget(ad: _nativeAd!,),
                // ) : Container(),

                ElevatedButton(
                    style:
                    ElevatedButton.styleFrom(primary: Colors.green.shade400),
                    onPressed: () {
                      navigation();
                      // _createInterstitialAd();
                    },
                    child: const Text(
                      "Let's Start",
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),top: 0,right: 0,left: 0,bottom: 0,),
            // Positioned(child: _isHeaderBannerLoaded
            //     ? Container(
            //   margin: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            //   child: AdWidget(
            //     ad: _headerBanner!,
            //   ),
            //   height: _headerBanner!.size.height.toDouble(),
            //   width: _headerBanner!.size.width.toDouble(),
            // )
            //     : Container(),top: 0,right: 0,left: 0,),
          ],),
          padding: const EdgeInsets.all(16)),
      // bottomNavigationBar: _isBottomBannerLoaded
      //     ? SizedBox(
      //   child: AdWidget(ad: _bottomBanner!),
      //   height: _bottomBanner!.size.height.toDouble(),
      //   width: _bottomBanner!.size.width.toDouble(),
      // )
      //     : Container(),
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
      builder: (context) => const GenderView(),
    ));
  }

  _shareApp() async {
    String link =
        "https://play.google.com/store/apps/details?id=ngaoschos.videodownloader";
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
