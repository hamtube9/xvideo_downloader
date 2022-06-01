import 'dart:io';

class AdsHelper{

  static String get bannerAdUtilId{
    if(Platform.isAndroid){
      return "ca-app-pub-7047183990898007~8963820251";
    }else if(Platform.isIOS){
      return "ca-app-pub-7047183990898007~4736004479";
    }
    else{
      throw UnsupportedError('Unsupport platform');
    }
  }


  static String get interstitialAdUnitId{
    if(Platform.isAndroid){
      return "ca-app-pub-7047183990898007~8141693178";
    }else if(Platform.isIOS){
      return "ca-app-pub-7047183990898007~2828822598";
    }
    else{
      throw UnsupportedError('Unsupport platform');
    }
  }
}