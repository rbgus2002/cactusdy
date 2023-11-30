

import 'package:flutter/material.dart';

class DashLine extends StatelessWidget {
  static const double lotSize = 12;

  final double width;
  final double height;
  final Color color;
  final bool bold;

  const DashLine({
    Key? key,
    required this.color,
    this.width = 32,
    this.height = 172,
    this.bold = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _DashLinePainter(
            color: color,
            strokeWidth: (bold)? 2.5 : 2,
            dashLength: 4,
            intervalLength: 8),),
    );
  }
}

class _DashLinePainter extends CustomPainter {
  Color color;
  double strokeWidth;
  double dashLength;
  double intervalLength;

  _DashLinePainter({
    required this.color,
    required this.strokeWidth,
    required this.dashLength,
    required this.intervalLength,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
        ..color = color
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke;

    double x = size.width / 2;
    for (double y = 0; y < size.height; y += dashLength + intervalLength) {
      double dashLen = (size.height - y > dashLength)? dashLength : (size.height - y);

      Offset begin = Offset(x, y);
      Offset end = Offset(x, y + dashLen);

      canvas.drawLine(begin, end, paint);
    }
  }

  @override
  bool shouldRepaint(_DashLinePainter oldDelegate) {
    return true;
  }
}
