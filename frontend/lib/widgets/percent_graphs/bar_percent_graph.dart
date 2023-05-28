import 'package:flutter/material.dart';
import 'dart:math';

import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/widgets/percent_graphs/percent_graph.dart';

class BarPercentGraph extends PercentGraph {
  final double width;

  BarPercentGraph({
    Key? key,
    required super.percentInfos,
    super.backgroundColor,
    super.stroke = 30,

    this.width = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: stroke,
        width: width,

        child: CustomPaint(
          painter: _BarPercentGraphPaint(
              percentInfos: percentInfos,
              backgroundColor: backgroundColor,
              stroke: stroke
          ),
        )
    );
  }
}

class _BarPercentGraphPaint extends CustomPainter {
  final Color backgroundColor;
  final double stroke;

  final List<PercentInfo> percentInfos;

  _BarPercentGraphPaint({
    required this.percentInfos,
    required this.backgroundColor,
    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double verticalBase = size.height * 0.5;

    final Offset leftPoint = Offset(0, verticalBase);
    Offset rightPoint = Offset(size.width, verticalBase);

    Paint paint = Paint()
      ..color = backgroundColor
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    double startPoint = 0;
    for (final PercentInfo percentInfo in percentInfos) {
      startPoint += percentInfo.percent;
    }

    // draw background line
    canvas.drawLine(leftPoint, rightPoint, paint);

    // draw progress line
    for (int i = percentInfos.length - 1; i >= 0; --i) {
      startPoint -= percentInfos[i].percent;

      rightPoint = Offset((startPoint + percentInfos[i].percent) * size.width, verticalBase);
      paint.color = percentInfos[i].color;

      canvas.drawLine(leftPoint, rightPoint, paint);
    }
  }

  @override
  bool shouldRepaint(_BarPercentGraphPaint oldDelegate) {
    return true;
  }
}
