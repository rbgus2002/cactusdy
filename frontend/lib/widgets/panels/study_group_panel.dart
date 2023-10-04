import 'package:flutter/material.dart';
import 'package:group_study_app/models/sign_info.dart';
import 'package:group_study_app/models/study_Info.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/study_detail_route.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/buttons/outline_circle_button.dart';
import 'package:group_study_app/widgets/line_profiles/study_line_profile_widget.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/circle_button_list.dart';
import 'package:group_study_app/widgets/participant_profile_list_widget.dart';
import 'package:group_study_app/widgets/round_info_widget.dart';
import 'package:group_study_app/widgets/tasks/task_group_widget.dart';

class StudyGroupPanel extends StatelessWidget {
  final StudyInfo studyInfo;

  const StudyGroupPanel({
    Key? key,
    required this.studyInfo,
  }) : super(key: key) ;

  @override
  Widget build(BuildContext context) {
    List<CircleButton> userImages = studyInfo.participantSummaries.map((e) =>
        OutlineCircleButton(scale: 24, image: null, stroke: 2,),).toList();
    return Panel(
        boxShadows: Design.basicShadows,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            StudyLineProfileWidget(study: studyInfo.study,
                bottomWidget: CircleButtonList(
                  circleButtons: userImages,
                  paddingVertical: 2,
                )),
            Design.padding10,
            RoundInfoWidget(roundSeq: studyInfo.roundSeq, round: studyInfo.round, studyId: studyInfo.study.studyId,),
            //ParticipantListWidget(studyId: studyId, scale: 26),
            Design.padding10,
            //RoundInformationWidget(round: Test.testRound),

            // task groups
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: studyInfo.taskGroups.length,
              itemBuilder: (context, index) => 
                TaskGroupWidget(taskGroup: studyInfo.taskGroups[index]),
            )
          ],
        ),
        onTap: () { Util.pushRoute(context, (context) => StudyDetailRoute(studyId: studyInfo.study.studyId,)); },
    );
  }
}
/*

                OutlineCircleButton(
                  image: null, scale: 55, color: Colors.red, stroke: 5,),
                Design.padding5,
                Flexible(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'STUDY GROUP NAME', style: TextStyles.titleMedium,),

                    CircleButtonList(
                      circleButtons:
                      List<User>.generate(30, (index) => Test.testUser),
                      onTap: Test.onTabTest,
                      scale: 24.0,
                    ),

                      ]),
class ReorderableTasks extends StatefulWidget {
  List<Task> tasks;
  const ReorderableTasks({Key? key}) : super(key: key);

  @override
  State<ReorderableTasks> createState() => _ReorderableTask();
}

class _ReorderableTasks extends State<ReorderableTasks> {
  late final List<int> _items;

  @override
  void initState() {
    super.initState();
    _items = List<int>.generate(widget.tasks.length, (int index) => index);
  }

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(children: children, onReorder: onReorder)
  }




}*/