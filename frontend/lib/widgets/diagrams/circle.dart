import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';

class Circle extends StatelessWidget {
  final Color color;
  final double scale;
  final double stroke;

  Circle({
    Key? key,
    required this.color,
    required this.scale,
    this.stroke = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scale,
      height: scale,

      child: CustomPaint(
        painter: _CirclePaint(
          color: color,
          stroke: stroke,
          )
        )
    );
  }
}

class _CirclePaint extends CustomPainter {
  final Color color;
  final double stroke;

  _CirclePaint({
    this.color = ColorStyles.grey,
    this.stroke = 15,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final double radius = (size.width - stroke) * 0.5;
    final Offset center = Offset(size.width * 0.5, size.height * 0.5);

    Paint paint = Paint()
      ..color = color
      ..strokeWidth = stroke
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // draw background circle
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_CirclePaint oldDelegate) {
    return true;
  }
}