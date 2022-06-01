import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:videodownloader/bloc/gallery_bloc.dart';
import 'package:videodownloader/bloc/gallery_provider.dart';
import 'package:videodownloader/utils/compare.dart';
import 'package:videodownloader/views/play_video_view.dart';

class GalleryView extends StatefulWidget {
  const GalleryView({Key? key}) : super(key: key);

  @override
  State<GalleryView> createState() => _GalleryViewState();
}

class _GalleryViewState extends State<GalleryView>
    with SingleTickerProviderStateMixin {

  late TabController _tabController;
  GalleryBloc? bloc;

  @override
  void initState() {
    super.initState();
    bloc = GalleryProvider.of(context);
    bloc!.loadFiles();
    _tabController = TabController(
      length: 4,
      vsync: this,
    )..addListener(() {
        if (_tabController.indexIsChanging) {}
      });
  }



  @override
  Widget build(BuildContext context) {
    double itemHeight =
        (MediaQuery.of(context).size.height - kToolbarHeight - 24) / 4;
    double itemWidth = MediaQuery.of(context).size.width / 4;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
              child: TabBar(
                controller: _tabController,
                indicatorColor: Colors.red,
                onTap: (v){
                  bloc!.onChangeList(v);
                },
                tabs: const [
                  Tab(
                      child: Text(
                    'Gallery',
                    style: TextStyle(color: Colors.black54),
                  )),
                  Tab(
                      child: Text('Status Gallery',
                          style: TextStyle(color: Colors.black54))),
                  Tab(
                      child: Text('Images',
                          style: TextStyle(color: Colors.black54))),
                  Tab(
                      child: Text('Audios',
                          style: TextStyle(color: Colors.black54))),
                ],
              ),
            ),
            Expanded(
              child:Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                child: ValueListenableBuilder<List<FileSystemEntity>?>(builder: (context, value, child) {
                  if(value != null && value.isNotEmpty){
                    return GridView.builder(
                        gridDelegate:
                        SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 8,
                            childAspectRatio: (itemWidth / itemHeight)),
                        itemCount: value.length,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int i) {
                          return GestureDetector(
                            child: item(value[i]),
                            onTap: () => selectItem(value[i]),
                          );
                        });
                  }
                  return Container();
                },valueListenable: bloc!.notifierFiles,
                ),
              )
            )
          ],
        ),
      ),
    );
  }

  item(FileSystemEntity item) {
    if (checkConstainsString(item.path, ['mp4', 'mov'])) {
      return FutureBuilder<Uint8List>(
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return videoItem(snapshot.data);
          }
          return Container();
        },
        future: getVideoPath(item.path),
      );
    } else if (checkConstainsString(item.path, ['mp3'])) {
      return Text(item.path);
    } else if (checkConstainsString(item.path, ['png', 'jpeg', 'jpg'])) {
      return Image.file(File(item.path));
    }

    return Text(item.path);
  }

  Future<Uint8List> getVideoPath(String path) async {
    final uint8list = await VideoThumbnail.thumbnailData(
      video: path,
      imageFormat: ImageFormat.JPEG,
      maxWidth: 128,
      quality: 25,
    );

    return uint8list!;
  }

  videoItem(Uint8List? data) {
    return SizedBox(
        height: 120,
        width: 80,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Stack(
            children: [
              Positioned(
                child: Image.memory(
                  data!,
                  fit: BoxFit.fill,
                ),
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
              ),
              const Positioned(
                child: Icon(
                  Icons.play_circle_outline,
                  color: Colors.grey,
                  size: 40,
                ),
                top: 0,
                right: 0,
                bottom: 0,
                left: 0,
              ),
            ],
          ),
        ));
  }

  selectItem(FileSystemEntity item) {
    if (checkConstainsString(item.path, ['mp4', 'mov'])) {
      showDialog(
          context: context,
          builder: (context) => PlayVideoView(path: item.path),
          useSafeArea: false);
    } else if (checkConstainsString(item.path, ['mp3'])) {
      return Text(item.path);
    } else if (checkConstainsString(item.path, ['png', 'jpeg', 'jpg'])) {
      return Image.file(File(item.path));
    }
  }
}
