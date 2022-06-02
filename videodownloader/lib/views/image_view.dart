import 'dart:io';

import 'package:flutter/material.dart';

class ImageView extends StatefulWidget {
  final String? path;
  const ImageView({Key? key, this.path}) : super(key: key);

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.0),
        child: Stack(
          children: [
            Positioned(
              child: Container(color: Colors.grey.shade500,),
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
            ),

            Positioned(
              child: Image.file(File(widget.path!)),
              top: 0,
              right: 0,
              bottom: 0,
              left: 0,
            ),
          ],
        ),
      ),
    );
  }


}
