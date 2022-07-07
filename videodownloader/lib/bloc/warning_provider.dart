
import 'package:flutter/material.dart';
import 'package:videodownloader/bloc/warning_bloc.dart';

class WarningProvider extends InheritedWidget {
  final WarningBloc? bloc;
  final Widget child;

  const WarningProvider({
    Key? key,
    this.bloc,
    required this.child,
  }) : super(key: key, child: child);

  static WarningBloc? of(BuildContext context) => context.findAncestorWidgetOfExactType<WarningProvider>()?.bloc;

  @override
  bool updateShouldNotify(covariant WarningProvider oldWidget) => true;
}