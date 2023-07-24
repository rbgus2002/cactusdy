import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/buttons/outline_circle_button.dart';
import 'package:group_study_app/widgets/line_profiles/line_profile_widget.dart';

class StudyLineProfileWidget extends StatelessWidget {
  static const double _scale = 50; //60
  static const double _stroke = 5;

  final Study study;

  const StudyLineProfileWidget({
    super.key,
    required this.study,
  });

  @override
  Widget build(BuildContext context) {
    return LineProfileWidget(
      circleButton: OutlineCircleButton(
        color: ColorStyles.red,
        scale: _scale,
        stroke: _stroke,
      ),

      topWidget: Text(study.studyName, maxLines: 1, style: TextStyles.titleMedium,),
      bottomWidget: Text(study.detail, maxLines: 1, style: TextStyles.bodyMedium, ),

      iconButton: IconButton(onPressed: (){}, icon: AppIcons.edit, iconSize: 20),
    );
  }
}