import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:videodownloader/model/category/category.dart';
import 'package:videodownloader/utils/ads_helper.dart';
import 'package:videodownloader/views/button_animation_color.dart';

class CategoryView extends StatefulWidget {
  const CategoryView({Key? key}) : super(key: key);

  @override
  State<CategoryView> createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {
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
  Widget build(BuildContext context) {
    var listCategories = categories;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Select your favorite websites topics'),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Wrap(spacing: 24, direction: Axis.horizontal, alignment: WrapAlignment.center, children: [
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
    );
  }

  buttonContinue() {
    return GestureDetector(
      onTap: () {},
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
}

