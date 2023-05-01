import 'package:flutter/material.dart';
import 'dart:math';

class CircleButton extends StatelessWidget {
  final String defaultImageFile = 'assets/images/default_profile.png';

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
      child: Container(
        width: scale,
        height: scale,

        child: Material(
          child: InkWell(
            child: image??Image.asset(defaultImageFile),
            onTap: () {
              if (onTap != null) {
                onTap();
              }
            },
          )
        ),
      )
    );
  }
}

class OutlineCircleButton extends CircleButton {
  OutlineCircleButton({ Key? key, double scale = 20, Image? image, var onTap})
      : super(key : key, scale: scale, image: image, onTap: onTap);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
        child: Container(
          width: scale,
          height: scale,

          child: CustomPaint(painter: PercentOutlinePaint(
              percent: 0.5,
              progressColor: Colors.green,
            ),
          )
        ),
    );
  }
}

class PercentOutlinePaint extends CustomPainter {
  double percent = 0.0;
  double textScaleFactor = 1.0; // 파이 차트에 들어갈 텍스트 크기를 정합니다.
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
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius),
        -pi / 2, arcAngle, false, paint);
  }

  @override
  bool shouldRepaint(PercentOutlinePaint oldDelegate) {
    return true;
  }
}