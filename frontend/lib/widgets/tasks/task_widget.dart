import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';

class TaskWidget extends StatefulWidget {
  //final int index;
  final Task task;
  final Animation<double> animation;

  TaskWidget({
    super.key,
    //required this.index,
    required this.task,
    required this.animation,
  });

  @override
  State<TaskWidget> createState() => _TaskWidget();
}

class _TaskWidget extends State<TaskWidget> {
  static const String _taskHintMessage = "할 일을 입력해 주세요";

  late final TextEditingController _textEditingController;
  bool _isEditable = false;

  @override
  void initState() {
    _textEditingController = TextEditingController(text: widget.task.detail);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.task.detail??"";
    return SizeTransition(
      sizeFactor: widget.animation,
      child: SizedBox(
        height: 26,
        child: GestureDetector(
          onTap: () {
            setState(() => _isEditable = true);
          },

          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,

            children: [
              SizedBox(
                width: 18,
                height: 18,
                child: Checkbox(
                  value: widget.task.isDone,
                  onChanged: (value) {
                    // Fast Unsafe State Update
                    setState(() { widget.task.isDone = value!; });

                    //< FIXME
                    // Call API and Verify State
                    Task.switchIsDone(widget.task.taskId, widget.task.isDone);
                  },
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
              ),
              Design.padding5,
              Flexible(
                fit: FlexFit.tight,
                child: TextField(
                  maxLines: 1,
                  style: TextStyles.taskTextStyle,

                  controller: _textEditingController,
                  decoration: InputDecoration(
                    hintText: _taskHintMessage,
                    isDense: true,
                    enabled: _isEditable,
                    contentPadding: EdgeInsets.zero,
                    disabledBorder: InputBorder.none,
                  ),
                  //textAlignVertical: TextAlignVertical.top,
                  onTapOutside: (event) {
                    if (_isEditable) { setState(() { _isEditable = false; }); }
                  },
                ),
              ),
              SizedBox(
                width: 24,
                height: 24,
                child :PopupMenuButton(
                  icon: const Icon(Icons.more_horiz, size: 16, color: Colors.grey,),
                  splashRadius: 12,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  offset: const Offset(0, 18),

                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: Text("수정하기", style: TextStyles.bodyMedium,),
                      onTap: () { setState(() { _isEditable = true; }); },
                    ),
                    PopupMenuItem(
                      child: Text("삭제하기", style: TextStyles.bodyMedium,),
                      //onTap: ,
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }
}