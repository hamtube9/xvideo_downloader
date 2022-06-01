import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:videodownloader/main.dart';
import 'package:videodownloader/utils/compare.dart';
import 'package:videodownloader/utils/constants.dart';

import '../model/token.dart';

class MainBloc extends ChangeNotifier {
  static const defaultPlatform =
      MethodChannel('ngaoschos.videodownloader/insta');

  ValueNotifier<bool> notifierDownload = ValueNotifier<bool>(false);
  ValueNotifier<double> notifierProgress = ValueNotifier<double>(0.0);
  ValueNotifier<PermissionStatus?> notifierPermission =
      ValueNotifier<PermissionStatus?>(null);

  ValueNotifier<String?> tokenIg = ValueNotifier<String?>(null);

  Future<void> downloadFile(String url) async {
    String? endpoint = loadEnpoint(url);
    String? type = loadType(url);
    if (notifierPermission.value == PermissionStatus.denied) {
      permission();
      return;
    }
    final dio = Dio();
    final t = DateFormat('yyyyMMdd-kk-mm').format(DateTime.now()) ;
    var dir = await getExternalStorageDirectory();

    try {
      await dio.download(url, "${dir!.path}/$type$t.$endpoint",
          onReceiveProgress: (rec, total) {
        notifierDownload.value = true;
        notifierProgress.value = ((rec / total) * 100);
        print(((rec / total) * 100).toStringAsFixed(0) + "%");
        // notifierProgress.value = ((rec / total) * 100).toStringAsFixed(0) + "%";
      });
    } catch (e) {
      print(e);
    }
    notifierDownload.value = false;
    // progressString = "Completed";
    print("Download completed");
    showNotification(Random().nextInt(2212),'Download Success','$type$t.$endpoint finished downloading','');
  }

  loginFb() async {
    final result =
        await FacebookAuth.i.login(permissions: ["public_profile", "email"]);
    print(result.accessToken!.token);
  }

  permission() async {
    var s = await Permission.storage.status;
    if (notifierPermission.value == null) {
      notifierPermission.value = s;
    }
    if (!s.isGranted) {
      var a = await Permission.storage.request();
      notifierPermission.value = a;
    }
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
    });
  }

  loadToken(String code) async {
    final client = Client();
    //  Dio dio = Dio();
    // var r = await dio.post("https://api.instagram.com/oauth/access_token",queryParameters:{"client_id": instaAppId, "redirect_uri": redirectUri, "client_secre"
    //     "t": instaAppSecret, "code": code, "grant_type": "authorization_code"} );
    //
    final response = await client
        .post(Uri.parse("https://api.instagram.com/oauth/access_token"), body: {
      "client_id": instaAppId,
      "redirect_uri": redirectUri,
      "client_secret": instaAppSecret,
      "code": code,
      "grant_type": "authorization_code"
    });
    var token = Token.fromMap(json.decode(response.body));
    print(token.access);
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
      print(e);
    }
  }

  String? loadEnpoint(String url) {
    if (checkConstainsString(url, ['mp4', 'mov'])) {
      return returnEnpoint(url, ['mp4', 'mov']);
    } else if (checkConstainsString(url, ['jpeg', 'jpg', 'png'])) {
      return returnEnpoint(url, ['jpeg', 'jpg', 'png']);
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
    }
    return '';
  }


}
