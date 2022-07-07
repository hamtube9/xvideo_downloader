import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:videodownloader/views/error_connect.dart';
import 'package:videodownloader/views/loading_screen.dart';

class StatusScreen extends StatefulWidget {
  final Widget mainWidget;
  final ConnectivityResult? connectivityResult;

  const StatusScreen({Key? key, required this.mainWidget, this.connectivityResult}) : super(key: key);

  @override
  _StatusScreenState createState() => _StatusScreenState();
}

class _StatusScreenState extends State<StatusScreen> {
  bool isConnected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _checkConnect();
    print(widget.connectivityResult);
  }

  _checkConnect() async {
    if(mounted){
      await Future.delayed(const Duration(milliseconds: 1000)).whenComplete(() {
        setState(() {
          isConnected = true;
        });
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: isConnected == false
          ? const LoadingScreen()
          : ((widget.connectivityResult == ConnectivityResult.wifi || widget.connectivityResult == ConnectivityResult.mobile) ? _mainWidget() : _errorScreen()),
    );
  }

  _mainWidget() {
    return widget.mainWidget;
  }

  _errorScreen() {
    return ErrorConnectionView(
      onclick: () => _checkConnect(),
    );
  }
}