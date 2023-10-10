import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/test.dart';

class Panel extends StatelessWidget {
  final Color backgroundColor;
  final List<BoxShadow>? boxShadows;
  final Function? onTap;
  final Widget? child;

  final double padding;
  final double marginBottom;

  const Panel({
    Key? key,
    this.backgroundColor = ColorStyles.panelBackgroundColor, //< FIXME
    this.boxShadows,
    this.onTap,
    this.child,
    this.padding = Design.padding,
    this.marginBottom = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (onTap == null) {
      return Container(
        margin: EdgeInsets.only(bottom: marginBottom),
        padding: Design.edge15,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Design.borderRadius),
          boxShadow: boxShadows,
          color: backgroundColor,
        ),
        child: child,
      );
    }

    else {
      return Container(
        margin: EdgeInsets.only(bottom: marginBottom),
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(Design.borderRadius),
            boxShadow: boxShadows,
            color: backgroundColor,
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(Design.borderRadius),
            onTap: () {  onTap!(); },
            child: Container(
              padding: Design.edge15,
              child: child,
            ),
            onLongPress: null,
          )
        ),
      );
    }
  }
}