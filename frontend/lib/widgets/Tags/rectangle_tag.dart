
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';

class RectangleTag extends StatelessWidget {
  static const EdgeInsets _rectangleTagPadding =
      EdgeInsets.symmetric(vertical: 6, horizontal: 8);

  final Text text;
  final Color color;
  final VoidCallback onTap;
  final EdgeInsets? padding;

  const RectangleTag({
    Key? key,
    required this.text,
    required this.color,
    required this.onTap,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Ink(
        decoration: BoxDecoration(
          borderRadius: Design.borderRadiusSmall,
          color: color,),
        child: InkWell(
          borderRadius: Design.borderRadiusSmall,
          onTap: onTap,
          child: Container(
            padding: padding??_rectangleTagPadding,
            child: text),),
    );
  }
}