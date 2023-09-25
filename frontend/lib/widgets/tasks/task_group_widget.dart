
import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/models/task_group.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:group_study_app/widgets/tasks/task_widget.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class TaskGroupWidget extends StatefulWidget {
  final TaskGroup taskGroup;

  const TaskGroupWidget({
    Key? key,
    required this.taskGroup,
  }) : super(key: key);

  @override
  State<TaskGroupWidget> createState() => _TaskGroupWidget();
}

class _TaskGroupWidget extends State<TaskGroupWidget> {
  static const String _taskEmptyMessage = "Nothing to do...";
  final GlobalKey<AnimatedListState> _taskListKey = GlobalKey<AnimatedListState>();

  late final ListModel<Task> _taskListModel;

  @override
  void initState() {
    super.initState();
    _taskListModel = ListModel<Task>(
        listKey: _taskListKey,
        initialItems: widget.taskGroup.tasks);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleWidget(title: widget.taskGroup.taskType, icon: AppIcons.add,
            onTap: () {
              _taskListModel.add(Task());
              setState(() { });
            },),

          AnimatedList(
            key: _taskListKey,
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,

            initialItemCount: _taskListModel.length,
            itemBuilder: _buildTask,
          ),

          if (_taskListModel.length <= 0)
            const Text(_taskEmptyMessage),
        ]
      );
  }
  /*
  Widget _buildRemovedItem(
      int item, BuildContext context, Animation<double> animation) {
    return TaskWidget(
      index: item,
      animation: animation,
      task: _personalTaskListModel[item],
      // No gesture detector here: we don't want removed items to be interactive.
    );
  }
   */

  Widget _buildTask(
      BuildContext context, int index, Animation<double> animation) {
    return TaskWidget(task: _taskListModel[index],
      animation: animation,);
  }
}