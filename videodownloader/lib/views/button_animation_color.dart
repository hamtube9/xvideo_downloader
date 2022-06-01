
import 'package:flutter/material.dart';

class ChangeRaisedButtonColor extends StatefulWidget {
  Function(bool)? onClick;
  final String text;
  final bool isSelected;

  ChangeRaisedButtonColor({Key? key, this.onClick, required this.text, required this.isSelected}) : super(key: key);

  @override
  ChangeRaisedButtonColorState createState() => ChangeRaisedButtonColorState();
}

class ChangeRaisedButtonColorState extends State<ChangeRaisedButtonColor> with SingleTickerProviderStateMixin {
  AnimationController? _animationController;
  Animation? _colorTween;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _colorTween = ColorTween(begin: Colors.grey.shade200, end: Colors.blue).animate(_animationController!);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _colorTween!,
      builder: (context, child) => RaisedButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18.0),
        ),
        animationDuration: const Duration(milliseconds: 500),
        child: Text(
          widget.text,
          style: TextStyle(color: widget.isSelected ? Colors.white : Colors.grey.shade600),
        ),
        color: _colorTween!.value,
        onPressed: () {
          if (widget.isSelected) {
            _animationController!.reverse();
          } else {
            _animationController!.forward();
          }
          widget.onClick!(!widget.isSelected);
        },
      ),
    );
  }
}