import 'package:flutter/material.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/widgets/tasks/task.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class TaskListWidget extends StatelessWidget {
  String title;
  List<Task> tasks;

  TaskListWidget({
    super.key,
    required this.title,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleWidget(title: title, icon: AppIcons.add),
      ],
    );
  }






}