

import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/models/task_group.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:group_study_app/widgets/task_list_title.dart';
import 'package:group_study_app/widgets/tasks/task_widget.dart';

class TaskGroupWidget extends StatefulWidget {
  final Color studyColor;
  final TaskGroup taskGroup;
  final Function? updateProgress;

  final Function(String, int, Function(Task))? subscribe;
  final Function(String, int, Task)? notify;

  const TaskGroupWidget({
    Key? key,
    required this.taskGroup,
    required this.studyColor,

    this.updateProgress,
    this.subscribe,
    this.notify,
  }) : super(key: key);

  @override
  State<TaskGroupWidget> createState() => TaskGroupWidgetState();
}

class TaskGroupWidgetState extends State<TaskGroupWidget> {
  late GlobalKey<AnimatedListState> _taskListKey;
  late ListModel<Task> _taskListModel;

  @override
  void initState() {
    super.initState();

    _initListModel();

    if (_isNeedToSubscribe()) {
      widget.subscribe!(
          widget.taskGroup.taskType,
          widget.taskGroup.roundParticipantId,
          _addTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_taskListModel.items != widget.taskGroup.tasks) {
      _initListModel();
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TaskListTitle(
              title: widget.taskGroup.taskType,
              onTap: () => _addTask(Task())),
          Design.padding12,

          AnimatedList(
            key: _taskListKey,
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            scrollDirection: Axis.vertical,

            initialItemCount: _taskListModel.length,
            itemBuilder: _buildTask,),

          //if (_taskListModel.length <= 0)
          //  const Text(_taskEmptyMessage),  //< FIXME : Empty Tasks Message
        ]
    );
  }

  bool _isNeedToSubscribe() {
    return widget.subscribe != null && widget.taskGroup.isShared;
  }

  void _initListModel() {
    _taskListKey = GlobalKey<AnimatedListState>();
    _taskListModel = ListModel<Task>(
      listKey: _taskListKey,
      items: widget.taskGroup.tasks,
      removedItemBuilder: _buildRemovedItem,);
  }

  void _addTask(Task task) {
    _taskListModel.add(task);
    setState(() { });

    if (widget.updateProgress != null) widget.updateProgress!();
  }

  Widget _buildRemovedItem(
      Task task, BuildContext context, Animation<double> animation) {
    return TaskWidget(
      index: 0,
      task: task,
      color: widget.studyColor,
      animation: animation,
      onUpdateTaskDetail: _updateTaskDetail,
      onDeleteTask: _deleteTask,
      onCheckTask: widget.updateProgress,
    );
  }

  Widget _buildTask(
      BuildContext context, int index, Animation<double> animation) {
    return TaskWidget(
      index: index,
      task: _taskListModel[index],
      color: widget.studyColor,
      animation: animation,
      onUpdateTaskDetail: _updateTaskDetail,
      onDeleteTask: _deleteTask,
      onCheckTask: widget.updateProgress,
    );
  }

  void _updateTaskDetail(Task task) {
    // #Case : added new task
    if (task.taskId == Task.nonAllocatedTaskId) {
      Task.createTask(task, widget.taskGroup.taskType, widget.taskGroup.roundParticipantId);

      // notify to other task groups
      if (widget.notify != null && widget.taskGroup.isShared) {
        widget.notify!(
            widget.taskGroup.taskType,            // type
            widget.taskGroup.roundParticipantId,  //
            Task(taskId: Task.nonAllocatedTaskId,
              detail: task.detail,
              isDone: task.isDone,),
        );
      }
    }
    // #Case : modified the task
    else {
      Task.updateTaskDetail(task, widget.taskGroup.roundParticipantId);
    }
  }

  void _deleteTask(Task task, int index) {
    if (task.taskId != Task.nonAllocatedTaskId) {
      Task.deleteTask(task.taskId, widget.taskGroup.roundParticipantId);
    }
    _taskListModel.removeAt(index);
    setState(() { });

    if (widget.updateProgress != null) widget.updateProgress!();
  }
}