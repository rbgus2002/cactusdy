import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';

class PercentInfo {
  double percent;
  Color color;

  PercentInfo({
    this.percent = 0.0,
    this.color = Colors.transparent,
  });
}

abstract class PercentGraph extends StatelessWidget {
  List<PercentInfo> percentInfos;

  PercentGraph({Key? key,
    required this.percentInfos,
  }) : super(key: key);
}