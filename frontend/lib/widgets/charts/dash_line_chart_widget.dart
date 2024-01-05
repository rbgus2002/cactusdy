

import 'package:flutter/material.dart';
import 'package:groupstudy/widgets/diagrams/dash_line.dart';

@Deprecated('we cant certain progress')
class DashLineChartWidget extends StatelessWidget {
  final double width;
  final double height;
  final double progress;
  final Color activateColor;
  final Color deactivateColor;

  const DashLineChartWidget({
    super.key,
    required this.width,
    required this.height,
    required this.progress,
    required this.activateColor,
    required this.deactivateColor,
  });

  @override
  Widget build(BuildContext context) {
    double deactivateLength = height * (1 - progress);
    deactivateLength -= (deactivateLength % DashLine.lotSize);

    return SizedBox(
      width: width,
      height: height,
      child: Column(
        children: [
          DashLine(
            height: deactivateLength,
            color: deactivateColor,),
          DashLine(
            height: height - deactivateLength,
            color: activateColor,
            bold: true,),
        ],
      ),
    );
  }
}
