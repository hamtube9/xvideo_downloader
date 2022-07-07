import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videodownloader/bloc/connectivity_notifier.dart';
import 'package:videodownloader/main.dart';
import 'package:videodownloader/services/download_service.dart';
import 'package:videodownloader/utils/compare.dart';
import 'package:videodownloader/utils/constants.dart';
import '../model/token.dart';

class MainBloc extends ConnectivityNotifier {
  final DownloadService service;

  MainBloc({
    required this.service,
  });

  static const defaultPlatform =
      MethodChannel('ngaoschos.videodownloader/insta');

  ValueNotifier<bool> notifierDownload = ValueNotifier<bool>(false);

  // ValueNotifier<double> notifierProgress = ValueNotifier<double>(0.0);
  ValueNotifier<String> notifierError = ValueNotifier<String>("");
  ValueNotifier<int> notifierTime = ValueNotifier<int>(0);
  ValueNotifier<PermissionStatus?> notifierPermission =
      ValueNotifier<PermissionStatus?>(null);

  ValueNotifier<String?> tokenIg = ValueNotifier<String?>(null);

  Future getUrlDownload(String url) async {
    if (await permission()) {
      var res = await service.getUrlVideo(url);
      if (res != null &&
          res.status == true &&
          res.output != null &&
          res.output!.isNotEmpty) {
        downloadFile(res.output!);
      } else {
        if (res == null || res != null && res.status == false) {
          notifierError.value = "Something went wrong!";
        } else if (res.status == true && res.output!.isEmpty) {
          notifierError.value = "Please wait! Next download time is 1 minute";
        }
      }
    }
    // notifierTime.value = 60;

    // downloadFile("https://video-hw.xvideos-cdn.com/videos/mp4/1/6/8/xvideos.com_168d1f6b70aeacd0dcb3f618be939a33.mp4?e=1654935773&ri=1024&rs=85&h=6fd910589f61583e7be52a3cb48c9481");
  }

  int coolDown = 60;
  Timer? _timerCooldown;

  void startTimeCooldown() {
    const oneSec = Duration(seconds: 1);
    _timerCooldown = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (coolDown == 0) {
          coolDown = 60;
          notifierDownload.value = false;
          timer.cancel();
        } else {
          coolDown--;
          notifierTime.value = coolDown;
        }
        print(coolDown);
      },
    );
  }

  Future<void> downloadFile(String url) async {
    String? endpoint = loadEnpoint(url);
    String? type = loadType(url);
    var dir = await getPathToDownload();
    final t = DateFormat('yyyyMMdd-kk-mm').format(DateTime.now());
    var path = "${dir}/$type$t.$endpoint";
    var exist = await File(path).exists();
    if (exist) {
      path =
          "${dir}/$type${DateFormat('MMdd-kk-mm').format(DateTime.now())}.$endpoint";
    }
    final dio = Dio();
    startTimeCooldown();
    try {
      //  await FlutterDownloader.enqueue(
      //   url: url,
      //   savedDir: path,
      //   saveInPublicStorage: true,
      //   showNotification: true, // show download progress in status bar (for Android)
      //   openFileFromNotification: true, // click on notification to open downloaded file (for Android)
      // );
      // FlutterDownloader.registerCallback((id, status,progress) {
      //   print(
      //       'Download task ($id) is in status ($status) and process ($progress)');
      // });
      var rd = Random().nextInt(2212);
      await dio.download(url, path, onReceiveProgress: (rec, total) {
        notifierDownload.value = true;
        // notifierProgress.value = ((rec / total) * 100);
        // print(((rec / total) * 100).toStringAsFixed(0) + "%");
        showProgress(rd,
            "$type${DateFormat('MMdd-kk-mm').format(DateTime.now())}.$endpoint",
            ((rec / total) * 100).toStringAsFixed(0) + "%",
            100,
            ((rec / total) * 100).toInt(),path);
        // notifierProgress.value = ((rec / total) * 100).toStringAsFixed(0) + "%";
      }).whenComplete(() {
        showNotification(rd, 'Download Success',
            '$type$t.$endpoint finished downloading', path);
        // notifierDownload.value = false;
      });
    } catch (e)  {
      await FirebaseCrashlytics.instance.recordError(
          e,
          StackTrace.current,
          reason: 'load banner ad error',
          fatal: true
      );
      print(e);
    }
    // progressString = "Completed";
    print("Download completed");
  }

  loginFb() async {
    final result =
        await FacebookAuth.i.login(permissions: ["public_profile", "email"]);
    print(result.accessToken!.token);
  }

  Future<bool> permission() async {
    var s = await Permission.storage.status;
    if (notifierPermission.value == null) {
      notifierPermission.value = s;
    }
    if (!s.isGranted) {
      var a = await Permission.storage.request();
      notifierPermission.value = a;
      return a.isGranted;
    }
    return s.isGranted;
  }

  loginInsta() async {
    String url =
        "https://api.instagram.com/oauth/authorize?client_id=$instaAppId&redirect_uri=$redirectUri&scope=user_profile,user_media&response_type=code";
    final flutterWebviewPlugin = FlutterWebviewPlugin();
    flutterWebviewPlugin.launch(url);
    flutterWebviewPlugin.onStateChanged.listen((event) {
      if (event.url.contains('code=')) {
        var code = event.url.split('code=').last;
        flutterWebviewPlugin.close();
        if (tokenIg.value == null) {
          tokenIg.value = code;
          loadToken(code);
        }
      }
    }).onError( (e) async {
      await FirebaseCrashlytics.instance.recordError(
          e,
          StackTrace.current,
          reason: 'load banner ad error',
          fatal: true
      );
    });
  }

  loadToken(String code) async {
    // final client = Client();
    // //  Dio dio = Dio();
    // // var r = await dio.post("https://api.instagram.com/oauth/access_token",queryParameters:{"client_id": instaAppId, "redirect_uri": redirectUri, "client_secre"
    // //     "t": instaAppSecret, "code": code, "grant_type": "authorization_code"} );
    // //
    // final response = await client
    //     .post(Uri.parse("https://api.instagram.com/oauth/access_token"), body: {
    //   "client_id": instaAppId,
    //   "redirect_uri": redirectUri,
    //   "client_secret": instaAppSecret,
    //   "code": code,
    //   "grant_type": "authorization_code"
    // });
    // var token = Token.fromMap(json.decode(response.body));
    // print(token.access);
  }

  String fbProtocolUrl() {
    if (Platform.isIOS) {
      return 'fb://profile/page_id';
    } else {
      return 'fb://page/page_id';
    }
  }

  void launchFb() async {
    if (await canLaunchUrl(Uri.parse(fbProtocolUrl()))) {
      await launchUrl(Uri.parse(fbProtocolUrl()));
    }
  }

  void launchInsta() async {
    try {
      await defaultPlatform.invokeMethod('launchInstagram');
    } catch (e) {
      await FirebaseCrashlytics.instance.recordError(
          e,
          StackTrace.current,
          reason: 'load banner ad error',
          fatal: true
      );
      print(e);
    }
  }

  String? loadEnpoint(String url) {
    if (checkConstainsString(url, ['mp4', 'mov'])) {
      return returnEnpoint(url, ['mp4', 'mov']);
    } else if (checkConstainsString(url, ['jpeg', 'jpg', 'png'])) {
      return returnEnpoint(url, ['jpeg', 'jpg', 'png']);
    } else if (checkConstainsString(url, ['m4a', 'mp3', 'ogg', 'wav'])) {
      return returnEnpoint(url, ['m4a', 'mp3', 'ogg', 'wav']);
    }
    return '';
  }

  String? returnEnpoint(String url, List<String> list) {
    if (list.where((element) => url.contains(element)).isNotEmpty) {
      return list.where((element) => url.contains(element)).first;
    }
    return null;
  }

  String? loadType(String url) {
    if (checkConstainsString(url, ['mp4', 'mov'])) {
      return 'vid';
    } else if (checkConstainsString(url, ['jpeg', 'jpg', 'png'])) {
      return 'image';
    } else if (checkConstainsString(url, ['m4a', 'mp3', 'ogg', 'wav'])) {
      return 'aud';
    }
    return '';
  }
}
