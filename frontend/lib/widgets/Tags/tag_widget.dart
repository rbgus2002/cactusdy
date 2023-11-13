
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';

class TagWidget extends StatelessWidget {
  final double width;
  final double height;
  final Text text;
  final Color color;
  final double radius;
  final VoidCallback onTap;

  const TagWidget({
    Key? key,
    required this.width,
    required this.height,
    required this.text,
    required this.color,
    required this.radius,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: color,),
      child: InkWell(
        borderRadius: BorderRadius.circular(radius),
        onTap: onTap,
        child: Center(child: text),),
    );
  }
}