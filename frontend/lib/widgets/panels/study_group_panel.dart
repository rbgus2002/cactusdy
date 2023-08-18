import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/buttons/outline_circle_button.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/circle_button_list.dart';
import 'package:group_study_app/widgets/round_info_widget.dart';
import 'package:group_study_app/widgets/task_list_widget.dart';

class StudyGroupPanel extends Panel {
  List<Task>? groupTasks;
  List<Task>? personalTasks;

  StudyGroupPanel({
    super.key,
    super.backgroundColor,

    super.width,
    super.height,
    super.padding,

    this.groupTasks,
    this.personalTasks,
    }) : super(
      boxShadows: Design.basicShadows,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          Row(
            children: [
              OutlineCircleButton(image: null, scale: 55, color: Colors.red, stroke: 5,),
              Design.padding5,
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text('STUDY GROUP NAME', style: TextStyles.titleMedium,),
                    /*< FIXME
                    CircleButtonList(
                      circleButtons:
                      List<User>.generate(30, (index) => Test.testUser),
                      onTap: Test.onTabTest,
                      scale: 24.0,
                    ),
                     */
                  ]),
              ),
            ],
          ),
          Design.padding5,
          //RoundInformationWidget(round: Test.testRound),

          TaskListWidget(
              studyId: -1, roundId: -1, userId: -1),
        ],
      )
    );
}
/*
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