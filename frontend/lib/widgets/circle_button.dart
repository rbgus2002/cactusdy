import 'package:flutter/material.dart';

import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/widgets/percent_outline.dart';

class CircleButton extends StatelessWidget {
  static const String defaultImageFile = 'assets/images/default_profile.png';

  final double scale;
  final Image? image;
  final onTap;

  const CircleButton({
    Key? key,
    this.scale: 20.0,
    this.image,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: scale,
        height: scale,

        child: Material(
          child: InkWell(
            child: image ?? Image.asset(defaultImageFile),
            onTap: () {
              if (onTap != null) {
                onTap();
              }
            },
        )),
      ));
  }
}

class OutlineCircleButton extends CircleButton {
  double percent = 0;
  Color color = ColorStyles.green;

  OutlineCircleButton(
      {Key? key, scale, required this.percent, image, super.onTap})
      : super(key: key, scale: scale, image: image);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: scale,
        height: scale,

        child: Material(
          child: InkWell(
            child: Stack(children: [
              image ?? Image.asset(CircleButton.defaultImageFile),
              PercentOutline(percent: percent, progressColor: color, scale: scale),
            ]),
            onTap: () {
              if (onTap != null) {
                onTap();
              }
            }
          ),
        ),
      )
    );
  }
}