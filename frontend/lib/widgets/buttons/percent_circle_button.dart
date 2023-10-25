import 'package:flutter/material.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/charts/chart.dart';
import 'package:group_study_app/widgets/charts/donut_chart.dart';

class PercentCircleButton extends CircleButton {
  final List<PercentInfo> percentInfos;

  const PercentCircleButton({
    Key? key,
    required this.percentInfos,

    required super.url,
    super.scale,
    super.onTap
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
        super.build(context),
        DonutChart(percentInfos: percentInfos, scale: scale),
      ]
    );
  }
}