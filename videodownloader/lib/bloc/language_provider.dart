import 'package:flutter/material.dart';
import 'package:videodownloader/bloc/language_bloc.dart';

class LanguageProvider extends InheritedWidget {
  final LanguageBloc? bloc;
  final Widget child;

  const LanguageProvider({
    Key? key,
    this.bloc,
    required this.child,
  }) : super(key: key, child: child);

  static LanguageBloc? of(BuildContext context) => context.findAncestorWidgetOfExactType<LanguageProvider>()?.bloc;

  @override
  bool updateShouldNotify(covariant LanguageProvider oldWidget) => true;
}