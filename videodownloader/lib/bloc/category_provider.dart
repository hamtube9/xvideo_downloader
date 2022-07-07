import 'package:flutter/material.dart';
import 'package:videodownloader/bloc/category_bloc.dart';

class CategoryProvider extends InheritedWidget {
  final CategoryBloc? bloc;
  final Widget child;

  const CategoryProvider({
    Key? key,
    this.bloc,
    required this.child,
  }) : super(key: key, child: child);

  static CategoryBloc? of(BuildContext context) => context.findAncestorWidgetOfExactType<CategoryProvider>()?.bloc;

  @override
  bool updateShouldNotify(covariant CategoryProvider oldWidget) => true;
}