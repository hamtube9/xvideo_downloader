import 'dart:io';

class AdsHelper{

  // static String appId = "ca-app-pub-7047183990898007~6727742994";
  static String appId = "ca-app-pub-7923546650751133~3748447166";

  static String get bannerAdUtilId{
    if(Platform.isAndroid){
      return "/22768871839/Banner_Allsize_ngaoschos.videodownloader";
      // return "ca-app-pub-7047183990898007/1396718205";
    }else if(Platform.isIOS){
      return "ca-app-pub-7047183990898007/4736004479";
    }
    else{
      throw UnsupportedError('Unsupport platform');
    }
  }
  static String get bannerAdUtilId2{
    if(Platform.isAndroid){
      return "/22768871839/Banner_Allsize_ngaoschos.videodownloader";
      // return "ca-app-pub-7047183990898007/1396718205";
    }else if(Platform.isIOS){
      return "ca-app-pub-7047183990898007/4736004479";
    }
    else{
      throw UnsupportedError('Unsupport platform');
    }
  }


  static String get loadingAdUnitId{
    if(Platform.isAndroid){
      return "/22768871839/Interstitial_ngaoschos.videodownloader";
      // return "ca-app-pub-7047183990898007/7032188261";
    }else if(Platform.isIOS){
      return "ca-app-pub-7047183990898007/5910678286";
    }
    else{
      throw UnsupportedError('Unsupport platform');
    }
  }


  static String get loadingOriginId{
    if(Platform.isAndroid){
      return "/22768871839/Native_ngaoschos.videodownloader";

      // return "ca-app-pub-7047183990898007/4730099184";
    }else if(Platform.isIOS){
      return "ca-app-pub-7047183990898007/5910678286";
    }
    else{
      throw UnsupportedError('Unsupport platform');
    }
  }
}