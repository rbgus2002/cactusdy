import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';

class TaskWidget extends StatefulWidget {
  final int index;
  final Task task;
  final Animation<double> animation;
  final Function onUpdateTaskDetail;
  final Function(Task, int) onDeleteTask;

  const TaskWidget({
    super.key,
    required this.index,
    required this.task,
    required this.animation,
    required this.onUpdateTaskDetail,
    required this.onDeleteTask,
  });

  @override
  State<TaskWidget> createState() => _TaskWidget();
}

class _TaskWidget extends State<TaskWidget> {
  static const String _taskHintMessage = "할 일을 입력해 주세요";

  static const String _modifyTaskText = "수정하기";
  static const String _deleteTaskText = "삭제하기";

  late final TextEditingController _textEditingController;
  late final FocusNode _focusNode;

  bool _isEditable = false;
  bool _isEdited = false;

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.task.detail);
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.task.detail ?? "";
    return SizeTransition(
      sizeFactor: widget.animation,
      child: SizedBox(
        height: 26,
        child: GestureDetector(
          onTap: () => setState(() => _isEditable = true),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _taskCheckBox(),
              Design.padding5,
              _taskDetail(),
              _taskPopupMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _taskCheckBox() {
    return SizedBox(
      width: 18,
      height: 18,
      child: Checkbox(
          value: widget.task.isDone,
          onChanged: (value) {
            // Fast Unsafe State Update
            setState(() => widget.task.isDone = value! );

            // FIXME : API WILL UPDATE
            // Call API and Verify State
            /*
            Task.switchTask(widget.task.taskId, roundParticipantId).then(
              (success) {
                if (success == false) widget.task.isDone = !value!;
            });
             */
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
    );
  }

  Widget _taskDetail() {
    return Flexible(
      fit: FlexFit.tight,
      child: TextField(
        maxLines: 1,
        style: TextStyles.taskTextStyle,
        focusNode: _focusNode,
        controller: _textEditingController,
        decoration: InputDecoration(
          hintText: _taskHintMessage,
          isDense: true,
          enabled: _isEditable,
          contentPadding: EdgeInsets.zero,
          disabledBorder: InputBorder.none,
        ),

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
      child : PopupMenuButton(
        icon: const Icon(Icons.more_horiz, size: 16, color: Colors.grey,),
        splashRadius: 12,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        offset: const Offset(0, 18),

        itemBuilder: (context) => [
          PopupMenuItem(
            child: const Text(_modifyTaskText, style: TextStyles.bodyMedium,),
            onTap: () {
              _isEditable = true;
              setState(() {
                Future.delayed(const Duration(milliseconds: 10)).then((value) =>
                  _focusNode.requestFocus());
            }); },
          ),
          PopupMenuItem(
            child: const Text(_deleteTaskText, style: TextStyles.bodyMedium,),
            onTap: () => widget.onDeleteTask(widget.task, widget.index),
          )
        ],
      )
    );
  }

  void _updateTask() {
    if (_isEditable) {
      if (_isEdited) {
        widget.task.detail = _textEditingController.text;
        widget.onUpdateTaskDetail(widget.task);
        _isEdited = false;
      }

      _isEditable = false;
      _focusNode.unfocus();
      setState(() { });
    }
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}