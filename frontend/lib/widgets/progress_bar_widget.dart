

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/utilities/animation_setting.dart';
import 'package:group_study_app/utilities/extensions.dart';

class ProgressBarWidget extends StatefulWidget {
  final double initProgress;

  const ProgressBarWidget({
    Key? key,
    required this.initProgress,
  }) : super(key: key);

  @override
  State<ProgressBarWidget> createState() => ProgressBarWidgetState();
}

class ProgressBarWidgetState extends State<ProgressBarWidget> with SingleTickerProviderStateMixin {
  double _progress = 0;

  @override
  void initState() {
    super.initState();
    _progress = widget.initProgress;
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

          AnimatedSize(
            curve: Curves.easeOutCubic,
            duration: AnimationSetting.animationDuration,
            child: Container(
              width: screenWidth * _progress,
              height: 4,
              color: ColorStyles.mainColor,),),
      ],
    );
  }

  set progress(double value) => setState(() => _progress = value );
}
