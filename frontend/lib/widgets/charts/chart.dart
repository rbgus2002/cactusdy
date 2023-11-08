import 'package:flutter/material.dart';
import 'package:group_study_app/themes/old_color_styles.dart';

class PercentInfo {
  double percent;
  Color color;

  PercentInfo({
    this.percent = 0.0,
    this.color = OldColorStyles.transparent,
  });
}

abstract class Chart extends StatelessWidget {
  List<PercentInfo> percentInfos;
  Color backgroundColor;
  double stroke;

  Chart({Key? key,
    required this.percentInfos,
    this.backgroundColor = OldColorStyles.grey,
    this.stroke = 5,
  }) : super(key: key);
}