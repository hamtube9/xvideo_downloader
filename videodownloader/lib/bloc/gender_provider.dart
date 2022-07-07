import 'package:flutter/material.dart';
import 'package:videodownloader/bloc/gender_bloc.dart';

class GenderProvider extends InheritedWidget {
  final GenderBloc? bloc;
  final Widget child;

  const GenderProvider({
    Key? key,
    this.bloc,
    required this.child,
  }) : super(key: key, child: child);

  static GenderBloc? of(BuildContext context) => context.findAncestorWidgetOfExactType<GenderProvider>()?.bloc;

  @override
  bool updateShouldNotify(covariant GenderProvider oldWidget) => true;
}