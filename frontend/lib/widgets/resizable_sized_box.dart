import 'package:flutter/material.dart';

class ResizableSizedBox extends StatefulWidget {
  Widget? child;

  double width;
  double height;

  final int duration;

  ResizableSizedBox({
    Key? key,
    this.width = 0.0,
    this.height = 0.0,

    this.duration = 1,
    this.child,
  }) : super(key: key);

  void fun() {
  }

  @override
  State<ResizableSizedBox> createState() => _ResizableSizedBox();
}

class _ResizableSizedBox extends State<ResizableSizedBox> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      width: widget.width,
      height: widget.height,
      duration: Duration(seconds: widget.duration),
      curve: Curves.fastOutSlowIn,

      child: widget.child,
    );
  }
}