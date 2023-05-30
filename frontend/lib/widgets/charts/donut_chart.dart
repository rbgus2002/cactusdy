import 'package:flutter/material.dart';
import 'dart:math';

import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/widgets/charts/chart.dart';

class DonutChart extends Chart {
  final double scale;
  final double ratio;

  DonutChart({
    Key? key,
    required super.percentInfos,
    super.backgroundColor,

    required this.scale,
    this.ratio = 0.1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scale,
      height: scale,

      child: CustomPaint(
        painter: _DonutChartPaint(
          percentInfos: percentInfos,
          backgroundColor: backgroundColor,
          stroke: ratio * scale,
        ),
      )
    );
  }
}

class _DonutChartPaint extends CustomPainter {
  final Color backgroundColor;
  final double stroke;

  final List<PercentInfo> percentInfos;

  _DonutChartPaint({
    required this.percentInfos,
    this.backgroundColor = ColorStyles.grey,
    this.stroke = 15,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (size.width - stroke) * 0.5;
    final Offset center = Offset(size.width * 0.5, size.height * 0.5);

    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double startAngle = -0.25;
    for (final PercentInfo percentInfo in percentInfos) {
      startAngle += percentInfo.percent;
    }
    startAngle = 2 * pi * startAngle;

    // draw background circle
    canvas.drawCircle(center, radius, paint);

    // draw progress arcs
    for (int i = percentInfos.length - 1; i >= 0; --i) {
      double arcAngle = 2 * pi * percentInfos[i].percent;
      paint.color = percentInfos[i].color;

      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startAngle, -arcAngle, false, paint);

      startAngle -= arcAngle;
    }
  }

  @override
  bool shouldRepaint(_DonutChartPaint oldDelegate) {
    return true;
  }
}
