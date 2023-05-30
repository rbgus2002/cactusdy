import 'package:flutter/material.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/charts/chart.dart';
import 'package:group_study_app/widgets/charts/donut_chart.dart';


class PercentCircleButton extends CircleButton {
  List<PercentInfo> percentInfos;

  final Widget? image;

  PercentCircleButton({
    Key? key,
    this.image,
    required this.percentInfos,
    super.scale,
    super.onTap
  }) : super(
    key: key,
    child: Stack(children: [
      image ?? Image.asset(CircleButton.defaultImagePath),
      DonutChart(percentInfos: percentInfos, scale: scale),
    ]),);
}