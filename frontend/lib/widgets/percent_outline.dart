import 'dart:ui';

import 'package:flutter/material.dart';
import 'dart:math';

import 'package:group_study_app/themes/color_styles.dart';

class PercentOutline extends StatelessWidget {
  late AnimationController percentAnimationController;

  Color progressColor = Colors.green;
  double scale;

  double percent = 0.0;
  double _newPercent = 0.0;

  PercentOutline({
    Key? key,
    required this.percent,
    required this.progressColor,
    required this.scale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scale,
      height: scale,

      child: CustomPaint(
        painter: PercentOutlinePaint(
          percent: percent,
          progressColor: progressColor,
        ),
      )
    );
  }
}

class PercentOutlinePaint extends CustomPainter {
  double percent = 0.0;
  Color backgroundColor = Colors.transparent;
  Color progressColor = ColorStyles.green;

  PercentOutlinePaint({required this.percent, required this.progressColor});

  @override
  void paint(Canvas canvas, Size size) {
    // line stroke : radius ratio
    double ratio = 0.1;

    double stroke = size.width * ratio;
    double radius = (size.width - stroke) * 0.5;
    double arcAngle = 2 * pi * percent;
    Offset center = Offset(size.width * 0.5, size.height * 0.5);

    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // draw background circle
    canvas.drawCircle(center, radius, paint);

    // draw progress circle
    paint.color = progressColor;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi * 0.5, arcAngle, false, paint);
  }

  @override
  bool shouldRepaint(PercentOutlinePaint oldDelegate) {
    return true;
  }
}
