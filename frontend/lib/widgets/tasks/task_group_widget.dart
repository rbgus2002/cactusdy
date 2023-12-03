

import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/models/task_group.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:group_study_app/utilities/stab_controller.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/task_list_title.dart';
import 'package:group_study_app/widgets/tasks/task_widget.dart';

class TaskGroupWidget extends StatefulWidget {
  final int userId;
  final Study study;
  final TaskGroup taskGroup;
  final Function? updateProgress;

  final Function(String, int, Function(Task))? subscribe;
  final Function(String, int, Task)? notify;

  const TaskGroupWidget({
    Key? key,
    required this.userId,
    required this.taskGroup,
    required this.study,

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

  late final bool _isOwner;

  @override
  void initState() {
    super.initState();
    _initListModel();
    _isOwner = Util.isOwner(widget.userId);

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
              enable: _isOwner,
              title: widget.taskGroup.taskTypeName,
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
        ]
    );
  }

  bool _isNeedToSubscribe() {
    return (widget.subscribe != null && widget.taskGroup.isShared);
  }

  void _initListModel() {
    _taskListKey = GlobalKey<AnimatedListState>();
    _taskListModel = ListModel<Task>(
      listKey: _taskListKey,
      items: widget.taskGroup.tasks,
      removedItemBuilder: _buildRemovedItem,);
  }

  void _addTask(Task task) {
    _taskListModel.insert(0, Task());

    if (widget.updateProgress != null) widget.updateProgress!();
  }

  Widget _buildRemovedItem(
      Task task, BuildContext context, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: TaskWidget(
        isOwner: _isOwner,
        task: task,
        color: widget.study.color,
        taskStabController: TaskStabController(
          studyId: widget.study.studyId,
          targetUserId: widget.userId,
          taskId: task.taskId,),
        onUpdateTaskDetail: _updateTaskDetail,
        onDeleteTask: (task) => _deleteTask(task, -1),
        onCheckTask: widget.updateProgress,
      ),
    );
  }

  Widget _buildTask(
      BuildContext context, int index, Animation<double> animation) {
    return SizeTransition(
      sizeFactor: animation,
      child: TaskWidget(
        isOwner: _isOwner,
        task: _taskListModel[index],
        color: widget.study.color,
        taskStabController: TaskStabController(
          studyId: widget.study.studyId,
          targetUserId: widget.userId,
          taskId: _taskListModel[index].taskId,),
        onUpdateTaskDetail: _updateTaskDetail,
        onDeleteTask: (task) => _deleteTask(task, index),
        onCheckTask: widget.updateProgress,
      ),
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
    if (!_isValidIndex(index)) return;

    if (task.taskId != Task.nonAllocatedTaskId) {
      Task.deleteTask(task.taskId, widget.taskGroup.roundParticipantId);
    }
    _taskListModel.removeAt(index);
    setState(() { });

    if (widget.updateProgress != null) widget.updateProgress!();
  }

  bool _isValidIndex(int index) {
    return (index >= 0 && index < _taskListModel.length);
  }
}