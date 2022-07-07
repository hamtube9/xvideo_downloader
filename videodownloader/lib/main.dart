// @dart=2.9
import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:videodownloader/bloc/gallery_bloc.dart';
import 'package:videodownloader/bloc/gallery_provider.dart';
import 'package:videodownloader/injection.dart';
import 'package:videodownloader/views/download_view.dart';
import 'package:videodownloader/views/gallery_view.dart';
import 'package:videodownloader/views/introduce_view.dart';
import 'package:videodownloader/views/language_view.dart';
import 'package:videodownloader/views/play_media_view.dart';
import 'package:videodownloader/views/splash_screen.dart';
import 'package:toast/toast.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
final navKey = GlobalKey<NavigatorState>();
ValueNotifier<ConnectivityResult> instantNotifierConnectivity =   ValueNotifier<ConnectivityResult>(null);
void main()  async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  configureDependencies();
  _initAds();
  noti();
  runApp(const MyApp());

}

_initAds() async {
  await MobileAds.instance.initialize();
  if (kDebugMode) {
    RequestConfiguration configuration = RequestConfiguration(
        testDeviceIds: ["46DECB1F2A9447C179291DE2970A74CB"]);
    MobileAds.instance.updateRequestConfiguration(configuration);
  }
}

noti() async {
  // await FlutterDownloader.initialize(
  //     debug: true, // optional: set to false to disable printing logs to console (default: true)
  //     ignoreSsl: true // option: set to false to disable working with http links (default: false)
  // );

  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/icon_xvideo_foreground');
  var initializationSettingsIOS = const IOSInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

  flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: (payload) => _onSelectNotification(payload));
}

_onSelectNotification(String payload) {
  print(payload);

  navKey.currentState.push(MaterialPageRoute(
    builder: (context) => PlayMediaView(path: payload),
  ));
}

Future<void> showNotification(
  int notificationId,
  String notificationTitle,
  String notificationContent,
  String payload, {
  String channelId = 'ngaoschos.VideoDownloader',
  String channelTitle = 'VideoDownloader Channel',
  String channelDescription = 'Default Android Channel for notifications',
  Priority notificationPriority = Priority.high,
  Importance notificationImportance = Importance.max,
}) async {
  var androidPlatformChannelSpecifics = AndroidNotificationDetails(
    channelId,
    channelTitle,
    channelDescription: channelDescription,
    playSound: false,
    importance: notificationImportance,
    priority: notificationPriority,
  );
  var iOSPlatformChannelSpecifics =
      const IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
    notificationId,
    notificationTitle,
    notificationContent,
    platformChannelSpecifics,
    payload: payload,
  );
}

showProgress(int id, String title, String percent, int maxProgress,
    int progress, String payload) async {
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails(title, 'progress channel',
          channelDescription: 'downloading',
          channelShowBadge: false,
          importance: Importance.max,
          priority: Priority.high,
          onlyAlertOnce: true,
          showProgress: true,
          maxProgress: maxProgress,
          progress: progress);
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin
      .show(id, percent, title, platformChannelSpecifics, payload: payload);
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorKey: navKey,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        builder: EasyLoading.init(),
        home: const SplashScreen());
  }
}

void toast(context, String message) {
  Toast.show(
    message,
    context,
    duration: 3,
    backgroundColor: Colors.black54,
    gravity: Toast.BOTTOM,
  );
}

void showLoading() {
  EasyLoading.show(maskType: EasyLoadingMaskType.black);
}

void hideLoading() {
  EasyLoading.dismiss(animation: false);
}


