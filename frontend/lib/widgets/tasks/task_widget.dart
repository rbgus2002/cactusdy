import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/custom_checkbox.dart';
import 'package:group_study_app/widgets/dialogs/two_button_dialog.dart';

class TaskWidget extends StatefulWidget {
  final int index;
  final Task task;
  final Color color;
  final Animation<double> animation;
  final Function(Task) onUpdateTaskDetail;
  final Function(Task, int) onDeleteTask;
  final Function? onCheckTask;

  const TaskWidget({
    super.key,
    required this.index,
    required this.task,
    required this.color,
    required this.animation,
    required this.onUpdateTaskDetail,
    required this.onDeleteTask,
    this.onCheckTask,
  });

  @override
  State<TaskWidget> createState() => _TaskWidget();
}

class _TaskWidget extends State<TaskWidget> {
  late final TextEditingController _textEditingController;
  late final FocusNode _focusNode;

  bool _isEdited = false;

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.task.detail);
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.task.detail;
    return SizeTransition(
      sizeFactor: widget.animation,
      child: Ink(
        height: 36,
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomCheckBox(
                value: widget.task.isDone,
                activeColor: widget.color,
                onChanged: _onChecked),
              Design.padding12,

              _taskDetail(),
              _taskPopupMenu(),
            ],
          ),
          onTap: () {},
        ),

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
        maxLines: 1,
        maxLength: Task.taskMaxLength,
        style: TextStyles.task.copyWith(
            color: context.extraColors.grey900),

        focusNode: _focusNode,
        controller: _textEditingController,
        decoration: InputDecoration(
          isDense: true,
          hintText: context.local.inputHint2(context.local.task),
          contentPadding: const EdgeInsets.symmetric(vertical: 4),
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
      width: 20,
      height: 20,
      child: IconButton(
        icon: const Icon(CustomIcons.more_horiz),
        iconSize: 20,
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
          onPressed2: () => widget.onDeleteTask(widget.task, widget.index),),),
    );
  }

  void _onChecked(bool? value) {
    if (widget.task.taskId == Task.nonAllocatedTaskId) return;

    // Fast Unsafe State Update
    widget.task.isDone = value!;

    // Call API and Verify State
    Task.switchTask(widget.task.taskId).then((result) =>
    widget.task.isDone = result);

    if (widget.onCheckTask != null) {
      widget.onCheckTask!();
    }
  }

  void _updateTask() {
    if (_isEdited) {
      widget.task.detail = _textEditingController.text;
      widget.onUpdateTaskDetail(widget.task);
      _isEdited = false;
    }

    _focusNode.unfocus();
    setState(() { });
  }

}