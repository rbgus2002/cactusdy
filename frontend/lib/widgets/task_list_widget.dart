import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:group_study_app/widgets/tasks/task_widget.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class TaskListWidget extends StatefulWidget {
  final int studyId;
  final int roundId;
  final int userId;

  const TaskListWidget({
    super.key,
    required this.studyId,
    required this.roundId,
    required this.userId,
  });

  @override
  State<TaskListWidget> createState() => _TaskListWidget();
}

class _TaskListWidget extends State<TaskListWidget> {
  static const String _groupTitle = "GROUP";
  static const String _personalTitle = "PERSONAL";
  static const String _taskEmptyMessage = "Nothing to do...";

  final GlobalKey<AnimatedListState> _groupTaskListKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _personalTaskListKey = GlobalKey<AnimatedListState>();

  late final Future<List<Task>> _groupTaskList;
  late final Future<List<Task>> _personalTaskList;
  late final ListModel<Task> _groupTaskListModel;
  late final ListModel<Task> _personalTaskListModel;

  // FIXME
  final int studyId = -1;
  final int roundId = -1;
  final int userId = -1;

  bool _isInit = false;

  @override
  void initState() {
    super.initState();
    _groupTaskList = Task.getGroupTasks(studyId, roundId, userId);
    _groupTaskList.then(
      (taskList) { _groupTaskListModel = ListModel(listKey: _groupTaskListKey, initialItems: taskList); }
    );
    _personalTaskList = Task.getPersonalTasks(studyId, roundId, userId);
    _personalTaskList.then(
      (taskList) { _personalTaskListModel = ListModel(listKey: _personalTaskListKey, initialItems: taskList); }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TitleWidget(title: _groupTitle, icon: AppIcons.add,
          onTap: () {
            _groupTaskListModel.add(Task());
          },),
        FutureBuilder(
          future: _groupTaskList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _isInit = true;

              if (_groupTaskListModel.length > 0) {
                return AnimatedList(
                  key: _groupTaskListKey,
                    shrinkWrap: true,
                    primary: false,
                    scrollDirection:  Axis.vertical,

                    initialItemCount: _groupTaskListModel.length,
                    itemBuilder: _buildGroupTask,
                );
              }
            }

            return const Text(_taskEmptyMessage);
          },
        ),
        Design.padding10,

        TitleWidget(title: _personalTitle, icon: AppIcons.add),
        FutureBuilder(
          future: _personalTaskList,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              _isInit = true;

              if (_personalTaskListModel.length > 0) {
                return AnimatedList(
                  key: _personalTaskListKey,
                  shrinkWrap: true,
                  primary: false,
                  scrollDirection:  Axis.vertical,

                  initialItemCount: _personalTaskListModel.length,
                  itemBuilder: _buildPersonalTask,
                );
              }
            }

            return const Text(_taskEmptyMessage);
          },
        ),
      ],
    );
  }

  Widget _buildGroupTask(
      BuildContext context, int index, Animation<double> animation) {
    return TaskWidget(task: _groupTaskListModel[index], animation: animation,);
  }

  Widget _buildPersonalTask(
      BuildContext context, int index, Animation<double> animation) {
    return TaskWidget(task: _personalTaskListModel[index],
    animation: animation,);
  }
}