import 'package:flutter/material.dart';
import 'dart:math';

import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/widgets/percent_graphs/percent_graph.dart';

class CirclePercentGraph extends PercentGraph {
  double scale;

  CirclePercentGraph({
    Key? key,
    required this.scale,
    required super.percentInfos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scale,
      height: scale,

      child: CustomPaint(
        painter: _CirclePercentGraphPaint(
          percentInfos: percentInfos
        ),
      )
    );
  }
}

class _CirclePercentGraphPaint extends CustomPainter {
  // ratio :'line_stroke':'radius' ratio
  double ratio;
  Color backgroundColor = Colors.transparent;

  final List<PercentInfo> percentInfos;

  _CirclePercentGraphPaint({
    this.ratio = 0.1,
    required this.percentInfos,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double stroke = size.width * ratio;
    double radius = (size.width - stroke) * 0.5;
    Offset center = Offset(size.width * 0.5, size.height * 0.5);

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
    double tmp = startAngle;

    // draw background circle
    canvas.drawCircle(center, radius, paint);

    // draw progress circles
    for (int i = percentInfos.length - 1; i >= 0; --i) {
      double arcAngle = 2 * pi * percentInfos[i].percent;
      paint.color = percentInfos[i].color;

      canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
          startAngle, -arcAngle, false, paint);

      startAngle -= arcAngle;
    }
  }

  @override
  bool shouldRepaint(_CirclePercentGraphPaint oldDelegate) {
    return true;
  }
}
