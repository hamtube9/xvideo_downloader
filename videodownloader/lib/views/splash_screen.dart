import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:videodownloader/bloc/introduce_bloc.dart';
import 'package:videodownloader/bloc/introduce_provider.dart';
import 'package:videodownloader/utils/constants.dart';
import 'package:videodownloader/views/introduce_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseCrashlytics.instance.setCustomKey(keyScreen, 'Splash View');
    Future.delayed(const Duration(milliseconds: 3000)).whenComplete(() {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) =>IntroduceProvider(child: const IntroduceView(),bloc: IntroduceBloc(),)),
      );
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/xvideodownloader.png',
                  height: 80,
                  width: 80,
                ),
                const Text(
                  'Video Downloader',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
            flex: 2,
          ),
          Expanded(
            child: Center(child: LoadingAnimationWidget.horizontalRotatingDots(
              color: Colors.white,
              size: 100,
            ),),
            flex: 1,
          )
        ],
      ),
    );
  }
}
