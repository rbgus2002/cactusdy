
import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/models/task_group.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/tasks/task_widget.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class TaskGroupWidget extends StatefulWidget {
  final TaskGroup taskGroup;
  final Function? updateProgress;

  final Function(String, int, Function(Task))? subscribe;
  final Function(String, int, Task)? notify;

  const TaskGroupWidget({
    Key? key,
    required this.taskGroup,
    this.updateProgress,

    this.subscribe,
    this.notify,
  }) : super(key: key);

  @override
  State<TaskGroupWidget> createState() => TaskGroupWidgetState();
}

class TaskGroupWidgetState extends State<TaskGroupWidget> {
  static const String _taskEmptyMessage = "Nothing to do...";

  final GlobalKey<AnimatedListState> _taskListKey = GlobalKey<AnimatedListState>();
  late final ListModel<Task> _taskListModel;

  @override
  void initState() {
    super.initState();
    _taskListModel = ListModel<Task>(
        listKey: _taskListKey,
        items: widget.taskGroup.tasks,
        removedItemBuilder: _buildRemovedItem,
    );

    if (widget.subscribe != null && widget.taskGroup.isShared) {
      widget!.subscribe!(
          widget.taskGroup.taskType,
          widget.taskGroup.roundParticipantId,
          addTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TitleWidget(title: widget.taskGroup.taskType, icon: AppIcons.add,
            onTap: () => addTask(Task())),

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

  void addTask(Task task) {
    _taskListModel.add(task);
    setState(() { });

    if (widget.updateProgress != null) widget.updateProgress!();
  }

  Widget _buildRemovedItem(
      Task task, BuildContext context, Animation<double> animation) {
    return TaskWidget(
      index: 0,
      task: task,
      animation: animation,
      onUpdateTaskDetail: updateTaskDetail,
      onDeleteTask: deleteTask,
      onCheckTask: widget.updateProgress,
    );
  }

  Widget _buildTask(
      BuildContext context, int index, Animation<double> animation) {
    return TaskWidget(
      index: index,
      task: _taskListModel[index],
      animation: animation,
      onUpdateTaskDetail: updateTaskDetail,
      onDeleteTask: deleteTask,
      onCheckTask: widget.updateProgress,
    );
  }

  void updateTaskDetail(Task task) {
    // #Case : added new task
    if (task.taskId == Task.nonAllocatedTaskId) {
      Task.createTask(task, widget.taskGroup.taskType, widget.taskGroup.roundParticipantId);

      // notify to other task groups
      if (widget.notify != null && widget.taskGroup.isShared) {
        widget.notify!(
          widget.taskGroup.taskType,
          widget.taskGroup.roundParticipantId,
          Task(taskId: Task.nonAllocatedTaskId,
            detail: task.detail,
            isDone: task.isDone,
          ),
        );
      }
    }
    // #Case : modified the task
    else {
      Task.updateTaskDetail(task, widget.taskGroup.roundParticipantId);
    }
  }

  void deleteTask(Task task, int index) {
    if (task.taskId != Task.nonAllocatedTaskId) {
      Task.deleteTask(task.taskId, widget.taskGroup.roundParticipantId);
    }
    _taskListModel.removeAt(index);
    setState(() { });

    if (widget.updateProgress != null) widget.updateProgress!();
  }
}