
import 'package:flutter/material.dart';
import 'package:videodownloader/bloc/introduce_bloc.dart';

class IntroduceProvider extends InheritedWidget {
  final IntroduceBloc? bloc;
  final Widget child;

  const IntroduceProvider({
    Key? key,
    this.bloc,
    required this.child,
  }) : super(key: key, child: child);

  static IntroduceBloc? of(BuildContext context) => context.findAncestorWidgetOfExactType<IntroduceProvider>()?.bloc;

  @override
  bool updateShouldNotify(covariant IntroduceProvider oldWidget) => true;
}