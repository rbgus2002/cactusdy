import 'package:flutter/material.dart';
import 'package:group_study_app/widgets/charts/chart.dart';

class BarChart extends Chart {
  final double width;

  BarChart({
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
          painter: _BarChartPaint(
              percentInfos: percentInfos,
              bar_chart: backgroundColor,
              stroke: stroke
          ),
        )
    );
  }
}

class _BarChartPaint extends CustomPainter {
  final Color bar_chart;
  final double stroke;

  final List<PercentInfo> percentInfos;

  _BarChartPaint({
    required this.percentInfos,
    required this.bar_chart,
    required this.stroke,
  });

  @override
  void paint(Canvas canvas, Size size) {
    double verticalBase = size.height * 0.5;

    final Offset leftPoint = Offset(0, verticalBase);
    Offset rightPoint = Offset(size.width, verticalBase);

    Paint paint = Paint()
      ..color = bar_chart
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
  bool shouldRepaint(_BarChartPaint oldDelegate) {
    return true;
  }
}
