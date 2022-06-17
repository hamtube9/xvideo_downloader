// @dart=2.9
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

// import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:videodownloader/injection.dart';
import 'package:videodownloader/views/download_view.dart';
import 'package:videodownloader/views/introduce_view.dart';
import 'package:videodownloader/views/splash_screen.dart';
import 'package:toast/toast.dart';

final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  configureDependencies();
  _initAds();
  noti();

  runApp(const MyApp());
}

_initAds() async {
  await MobileAds.instance.initialize();
  if (kDebugMode) {
    RequestConfiguration configuration =
        RequestConfiguration(testDeviceIds: ["A7454E1FD0E87DA10E30B70108A75C62"]);
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

  flutterLocalNotificationsPlugin.initialize(initializationSettings);
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
  var iOSPlatformChannelSpecifics = const IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  await flutterLocalNotificationsPlugin.show(
    notificationId,
    notificationTitle,
    notificationContent,
    platformChannelSpecifics,
    payload: payload,
  );
}

showProgress(String title,String percent,int maxProgress, int progress) async {
  final AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'progress channel', 'progress channel',
      channelDescription: 'progress channel description',
      channelShowBadge: false,
      importance: Importance.max,
      priority: Priority.high,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: maxProgress,
      progress: progress);
  final NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);
  await flutterLocalNotificationsPlugin.show(
      0, percent,title, platformChannelSpecifics,
      payload: 'item x');
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
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
