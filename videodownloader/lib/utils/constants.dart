import 'package:ext_storage/ext_storage.dart';


final keyScreen= "screen_navigation";
final instaAppId = "1070357040241164";
final instaAppSecret = "13438714b13fdde4f1b922b027050d73";
final redirectUri = "https://www.google.com/";

Future<String> getPathToDownload() async {
  return ExtStorage.getExternalStoragePublicDirectory(ExtStorage.DIRECTORY_DOWNLOADS);
}
