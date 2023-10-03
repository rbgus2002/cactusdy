import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/diagrams/circle.dart';

class OutlineCircleButton extends CircleButton {
  final Widget? image;
  final Color color;
  final double stroke;

  OutlineCircleButton({
    Key? key,
    this.image,
    this.color = ColorStyles.grey,
    this.stroke = 15,

    super.scale,
    super.onTap
  }) : super(
    key: key,
    child: Stack(
        alignment: Alignment.center,
        children: [
          image ?? Image.asset(CircleButton.defaultImagePath),
          //Circle(color: Colors.grey, scale: scale, stroke: stroke,),
          Circle(color: color, scale: scale, stroke: stroke,),
        ]
    ),
  );
}