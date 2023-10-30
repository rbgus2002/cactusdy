import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/themes/old_app_icons.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/buttons/outline_circle_button.dart';
import 'package:group_study_app/widgets/line_profiles/line_profile_widget.dart';
import 'package:group_study_app/widgets/participant_profile_list_widget.dart';

class StudyLineProfileWidget extends StatelessWidget {
  static const double _scale = 50;
  static const double _stroke = 4;

  final Study study;
  final Widget? bottomWidget;

  const StudyLineProfileWidget({
    super.key,
    required this.study,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    return LineProfileWidget(
      circleButton: OutlineCircleButton(
        url: study.picture,
        color: study.color,
        scale: _scale,
        stroke: _stroke,
        borderRadius: _scale / 2,
      ),

      topWidget: Text(
        study.studyName, maxLines: 1, style: OldTextStyles.titleMedium,),
      bottomWidget: bottomWidget ?? Text(study.detail,
        maxLines: 1, style: OldTextStyles.bodyMedium,),

      suffixWidget: IconButton(
        icon: OldAppIcons.edit,
        splashRadius: 16,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        iconSize: 18,
        onPressed: () {}, //< FIXME
      ),
    );
  }
}