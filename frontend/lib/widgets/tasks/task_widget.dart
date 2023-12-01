import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/dialogs/two_button_dialog.dart';
import 'package:group_study_app/widgets/task_check_box.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  final Color color;
  final Function(Task) onUpdateTaskDetail;
  final Function(Task) onDeleteTask;
  final Function? onCheckTask;

  const TaskWidget({
    super.key,
    required this.task,
    required this.color,
    required this.onUpdateTaskDetail,
    required this.onDeleteTask,
    this.onCheckTask,
  });

  @override
  State<TaskWidget> createState() => _TaskWidget();
}

class _TaskWidget extends State<TaskWidget> {
  final _textEditingController = TextEditingController();
  final _focusNode = FocusNode();

  bool _isEdited = false;

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.task.detail;
    return Ink(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: Util.doNothing, // For prevent miss touch
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TaskCheckBox(
              task: widget.task,
              activeColor: widget.color,
              onChanged: _onChecked),
            Design.padding12,

            _taskDetail(),
            _taskPopupMenu(),
          ],),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _taskDetail() {
    return Flexible(
      fit: FlexFit.tight,
      child: TextField(
        minLines: 1,
        maxLines: 10,
        maxLength: Task.taskMaxLength,
        style: TextStyles.task.copyWith(
            color: context.extraColors.grey900,),
        strutStyle: const StrutStyle(
          leading: 0.6,),

        focusNode: _focusNode,
        controller: _textEditingController,
        textAlign: TextAlign.justify,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          isDense: true,
          hintText: context.local.inputHint2(context.local.task),
          contentPadding: EdgeInsets.zero,
          counterText: "",
          border: InputBorder.none,
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: context.extraColors.grey700!,),),),

        onChanged: (value) => _isEdited = true,
        onTapOutside: (event) => _updateTask(),
        onSubmitted: (value) => _updateTask(),
      ),
    );
  }

  Widget _taskPopupMenu() {
    return SizedBox(
      width: 24,
      height: 24,
      child: IconButton(
        icon: const Icon(CustomIcons.more_horiz),
        iconSize: 24,
        color: context.extraColors.grey500,
        splashRadius: 10,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        onPressed: () => TwoButtonDialog.showProfileDialog(
          context: context,
          text: widget.task.detail,

          buttonText1: context.local.modify,
          isOutlined1: true,
          onPressed1: () => _focusNode.requestFocus(),

          buttonText2: context.local.delete,
          isOutlined2: false,
          onPressed2: () => widget.onDeleteTask(widget.task),),),
    );
  }

  void _onChecked() {
    if (widget.task.taskId == Task.nonAllocatedTaskId) return;

    // Fast Unsafe State Update
    setState(() => widget.task.isDone = !widget.task.isDone);

    // Call API and Verify State
    Task.switchTask(widget.task.taskId).then((result) {
      if (result != widget.task.isDone) {
        setState(() => widget.task.isDone = result);
      }
    });

    if (widget.onCheckTask != null) {
      widget.onCheckTask!();
    }
  }

  void _updateTask() {
    if (_isEdited) {
      widget.task.detail = _textEditingController.text;

      if (widget.task.detail.isNotEmpty) {
        widget.onUpdateTaskDetail(widget.task);
      } else {
        widget.onDeleteTask(widget.task);
      }
      _isEdited = false;
    }

    _focusNode.unfocus();
    setState(() { });
  }
}