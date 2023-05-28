import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';

class PercentInfo {
  double percent;
  Color color;

  PercentInfo({
    this.percent = 0.0,
    this.color = ColorStyles.transparent,
  });
}

abstract class PercentGraph extends StatelessWidget {
  List<PercentInfo> percentInfos;
  Color backgroundColor;
  double stroke;

  PercentGraph({Key? key,
    required this.percentInfos,
    this.backgroundColor = ColorStyles.grey,
    this.stroke = 5,
  }) : super(key: key);
}