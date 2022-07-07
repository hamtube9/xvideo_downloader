
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:videodownloader/main.dart';

class ConnectivityNotifier extends ChangeNotifier{
  ValueNotifier<ConnectivityResult?> notifierConnectivity = ValueNotifier<ConnectivityResult?>(null);

  initNotifierConnectivity(){
    if(instantNotifierConnectivity.value != null){
      notifierConnectivity.value = instantNotifierConnectivity.value;
    }
    Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      notifierConnectivity.value = result;
      instantNotifierConnectivity.value = result;
    });
  }
}