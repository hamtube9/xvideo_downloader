import 'package:flutter/material.dart';

class TabbarGalleryView extends StatefulWidget {
  final Function(int)? onChangeTab;
  const TabbarGalleryView({Key? key, this.onChangeTab}) : super(key: key);

  @override
  State<TabbarGalleryView> createState() => _TabbarGalleryViewState();
}

class _TabbarGalleryViewState extends State<TabbarGalleryView>  with SingleTickerProviderStateMixin{
  late TabController _tabController;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: 4,
      vsync: this,
    )..addListener(() {
      if (_tabController.indexIsChanging) {}
    });
  }
  @override
  Widget build(BuildContext context) {
    return   Container(
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 16),
      child: TabBar(
        controller: _tabController,
        indicatorColor: Colors.red,
        onTap: (v){
          widget.onChangeTab!(v);
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
    );
  }
}
