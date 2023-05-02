import 'package:flutter/material.dart';
import 'dart:math';

import 'package:group_study_app/themes/color_styles.dart';

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
          child:
          Stack(children: [
        Image.asset('assets/images/default_profile.png',
            width: scale, height: scale),
        PercentOutline(percent: percent, progressColor: color, scale: scale)
      ]),
    onTap: () {
    if (onTap != null) {
    onTap();
    }
    }),
    ),
      )
    );
  }
}

class PercentOutline extends StatelessWidget {
  double percent;
  double scale;
  Color progressColor = Colors.green;

  PercentOutline({
    Key? key,
    required this.percent,
    required this.progressColor,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: scale,
        height: scale,
        child: CustomPaint(
          painter: PercentOutlinePaint(
            percent: percent,
            progressColor: progressColor,
          ),
        ));
  }
}

class PercentOutlinePaint extends CustomPainter {
  double percent = 0.0;
  Color backgroundColor = Colors.grey;
  Color progressColor = Colors.green;

  PercentOutlinePaint({required this.percent, required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = 15.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double radius = size.width / 2;
    double arcAngle = 2 * pi * percent;
    Offset center = Offset(size.width / 2, size.height / 2);

    // draw background circle
    canvas.drawCircle(center, radius, paint);

    // draw progress circle
    paint.color = progressColor;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        arcAngle, false, paint);
  }

  @override
  bool shouldRepaint(PercentOutlinePaint oldDelegate) {
    return true;
  }
}
