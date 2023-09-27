import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/Tags/user_state_tag.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/buttons/percent_circle_button.dart';
import 'package:group_study_app/widgets/charts/chart.dart';
import 'package:group_study_app/widgets/dialogs/user_profile_dialog.dart';
import 'package:group_study_app/widgets/line_profiles/line_profile_widget.dart';

class ParticipantLineProfileWidget extends StatelessWidget {
  static const double _scale = 50;
  final int userId = Test.testUser.userId;

  final User user;
  final double taskProgress;

  ParticipantLineProfileWidget({
    super.key,
    required this.user,
    required this.taskProgress,
  });

  @override
  Widget build(BuildContext context) {
    Color progressColor = Util.progressToColor(taskProgress);

    return LineProfileWidget(
      circleButton: PercentCircleButton(
        image: null,
        scale: _scale,
        percentInfos: [ PercentInfo(percent: taskProgress, color: progressColor)],
        onTap: () => UserProfileDialog.showProfileDialog(context, user.userId),
      ),

      topWidget: Text(user.nickname, maxLines: 1, style: TextStyles.titleMedium,),
      bottomWidget: Text("${(taskProgress * 100).toStringAsFixed(1)}%",
          style: TextStyle(
            fontSize: 16,
            fontWeight: TextStyles.extraBold,
            color: progressColor,
          ),
      ),

      suffixWidget: UserStateTag(
          color: Colors.red
      ),
    );
  }
}