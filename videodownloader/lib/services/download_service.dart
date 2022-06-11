import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:videodownloader/model/url_model/url.dart';

@injectable
class DownloadService {
  Future<UrlModel?> getUrlVideo(String url) async {
    try {
      BaseOptions options = BaseOptions(baseUrl: "http://18.medialoading.xyz");
      var response = await Dio(options)
          .get('/api/get-link', queryParameters: {'input': url});
      if(response.statusCode == 200 && response.data != null){
        var url = urlModelFromJson(jsonEncode(response.data));
       return url;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }
}
