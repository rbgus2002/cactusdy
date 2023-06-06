import 'package:flutter/material.dart';
import 'package:group_study_app/widgets/charts/chart.dart';

class BarChart extends Chart {
  final double width;

  BarChart({
    Key? key,
    required super.percentInfos,
    super.backgroundColor,
    super.stroke = 25,

    this.width = 100,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: stroke,
        width: double.infinity,

        child: CustomPaint(
          painter: _BarChartPaint(
              percentInfos: percentInfos,
              backgroundColor: backgroundColor,
              stroke: stroke
          ),
        )
    );
  }
}

class _BarChartPaint extends CustomPainter {
  final Color backgroundColor;
  final double stroke;

  final List<PercentInfo> percentInfos;

  _BarChartPaint({
    required this.percentInfos,
    required this.backgroundColor,
    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double verticalBase = size.height * 0.5;
    double radius = stroke * 0.5;
    double width = size.width - radius;

    final Offset leftPoint = Offset(radius, verticalBase);
    Offset rightPoint = Offset(width, verticalBase);

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

      rightPoint = Offset((startPoint + percentInfos[i].percent) * width, verticalBase);
      paint.color = percentInfos[i].color;

      canvas.drawLine(leftPoint, rightPoint, paint);
    }
  }

  @override
  bool shouldRepaint(_BarChartPaint oldDelegate) {
    return true;
  }
}
