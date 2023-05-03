import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';

class Panel extends StatelessWidget {
  final Color backgroundColor;
  final List<BoxShadow>? boxShadows;
  final Widget child;

  final double? width;
  final double? height;
  final double padding;

  const Panel({
    Key? key,
    this.backgroundColor = ColorStyles.panelBackgroundColor, //< FIXME
    this.boxShadows,

    required this.child,
    this.width,
    this.height,
    this.padding = Design.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),

      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(Design.borderRadius),
        boxShadow: boxShadows,
      ),
      child: child,
    );
  }
}