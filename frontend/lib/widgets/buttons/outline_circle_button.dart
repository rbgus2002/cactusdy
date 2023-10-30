import 'package:flutter/material.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';

class OutlineCircleButton extends CircleButton {
  final Color color;
  final double stroke;

  const OutlineCircleButton({
    Key? key,
    this.color = OldColorStyles.grey,
    this.stroke = 15,

    required super.url,
    super.scale,
    super.borderRadius,
    super.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double out = (borderRadius??scale/2) + stroke;
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(out),
        border: Border.all(
          width: stroke,
          color: OldColorStyles.red,
        )
      ),
      child : super.build(context),
    );
  }
}