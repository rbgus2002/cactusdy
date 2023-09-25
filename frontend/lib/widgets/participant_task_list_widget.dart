
import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_info.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/line_profiles/user_line_profile_widget.dart';
import 'package:group_study_app/widgets/tasks/task_group_widget.dart';

class ParticipantTaskListWidget extends StatelessWidget {
  final ParticipantInfo participantInfo;

  const ParticipantTaskListWidget({
    Key? key,
    required this.participantInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        UserLineProfileWidget(user: participantInfo.participant,
          bottomWidget: Text("${participantInfo.taskProgress * 100}%",
            style: TextStyle(
                fontSize: 16,
                fontWeight: TextStyles.extraBold,),
          ),
        ),
        Design.padding10,

        TaskGroupWidget(
          taskGroup: participantInfo.groupTasks,
        ),
        Design.padding10,

        TaskGroupWidget(
          taskGroup: participantInfo.personalTasks,
        ),
      ],
    );
  }
}