

import 'package:flutter/material.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/utilities/animation_setting.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/util.dart';

class ProgressBarWidget extends StatefulWidget {
  final double initProgress;

  const ProgressBarWidget({
    super.key,
    required this.initProgress,
  });

  @override
  State<ProgressBarWidget> createState() => ProgressBarWidgetState();
}

class ProgressBarWidgetState extends State<ProgressBarWidget> with SingleTickerProviderStateMixin {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 200), () =>
      setState(() => _progress = widget.initProgress));
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        Container(
          width: screenWidth,
          height: 4,
          color: context.extraColors.grey100,),

        AnimatedContainer(
          height: 4,
          width: screenWidth * _progress,
          curve: Curves.easeOutCubic,
          duration: AnimationSetting.animationDuration,
          alignment: Alignment.centerLeft,
          color: ColorStyles.mainColor,),
      ],
    );
  }

  set progress(double value) => setState(() => _progress = value );
}
