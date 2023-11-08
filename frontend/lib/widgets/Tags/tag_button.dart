import 'package:flutter/material.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';

class TagButton extends StatelessWidget{
  static const double height = 20;

  Color color;

  final EdgeInsets? padding;
  final Widget? child;
  final Function? onTap;

  TagButton({
    Key? key,
    this.color = OldColorStyles.transparent,
    this.padding,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: height, minWidth: height * 2.25),
      height: height,
      padding: padding,

      margin: const EdgeInsets.fromLTRB(0, 0, 5, 0),
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(height * 0.5),
        ),
      child: InkWell(
        borderRadius: BorderRadius.circular(height * 0.5),
        child: Center(
          widthFactor: 1,
          child: child,
        ),
        onTap: () {
          if (onTap != null) {
            onTap!();
          }
        },
      )
    );
  }
}