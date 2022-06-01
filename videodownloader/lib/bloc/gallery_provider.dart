
import 'package:flutter/material.dart';
import 'package:videodownloader/bloc/gallery_bloc.dart';

class GalleryProvider extends InheritedWidget {
  final GalleryBloc? bloc;
  final Widget child;

  const GalleryProvider({
    Key? key,
    this.bloc,
    required this.child,
  }) : super(key: key, child: child);

  static GalleryBloc? of(BuildContext context) => context.findAncestorWidgetOfExactType<GalleryProvider>()?.bloc;

  @override
  bool updateShouldNotify(covariant GalleryProvider oldWidget) => true;
}