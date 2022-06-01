

import 'package:flutter/material.dart';
import 'package:videodownloader/bloc/main_bloc.dart';

class MainProvider extends InheritedWidget {
  final MainBloc? bloc;
  final Widget child;

  const MainProvider({
    Key? key,
    this.bloc,
    required this.child,
  }) : super(key: key, child: child);

  static MainBloc? of(BuildContext context) => context.findAncestorWidgetOfExactType<MainProvider>()?.bloc;

  @override
  bool updateShouldNotify(covariant MainProvider oldWidget) => true;
}