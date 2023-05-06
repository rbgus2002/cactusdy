import 'package:flutter/material.dart';

import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/widgets/percent_graphs/circle_percent_graph.dart';
import 'package:group_study_app/widgets/percent_graphs/percent_graph.dart';

class CircleButton extends StatelessWidget {
  static const String defaultImagePath = 'assets/images/default_profile.png';

  final double scale;
  final Widget? child;
  final Function? onTap;

  const CircleButton({
    Key? key,
    this.scale = 20.0,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: scale,
        height: scale,

        child: Material(
          child: InkWell(
            child: child ?? Image.asset(defaultImagePath),
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
        )),
      ));
  }
}

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
        CirclePercentGraph(percentInfos: percentInfos, scale: scale),
      ]),);
}