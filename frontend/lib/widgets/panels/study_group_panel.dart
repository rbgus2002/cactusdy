import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/buttons/outline_circle_button.dart';
import 'package:group_study_app/widgets/buttons/percent_circle_button.dart';
import 'package:group_study_app/widgets/charts/chart.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/tasks/check_box_task.dart';
import 'package:group_study_app/widgets/tasks/task.dart';
import 'package:group_study_app/widgets/user_list_button.dart';
import 'package:group_study_app/widgets/round_info.dart';

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
                    UserListButton(
                      userList:
                      List<User>.generate(30, (index) => Test.testUser),
                      onTap: Test.onTabTest,
                      scale: 24.0,
                    ),
                  ]),
              ),
            ],
          ),
          Design.padding5,
          RoundInfo(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26),tag: "asd"),

          Design.padding15,
          const Text("GROUP", style: TextStyles.titleSmall,),
          CheckBoxTask(taskid: 0, text: "백준 : 1203번 풀기"),
          CheckBoxTask(taskid: 0, text: "백준 : 23092번 풀기"),

          Design.padding15,
          const Text("PERSONAL", style: TextStyles.titleSmall,),
          CheckBoxTask(taskid: 0, text: "알고리즘 강의 듣기"),
          CheckBoxTask(taskid: 0, text: "Flutter 강의 듣기"),
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