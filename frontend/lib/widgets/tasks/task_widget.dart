import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';

class TaskWidget extends StatefulWidget {
  final Task task;
  final Animation<double> animation;

  TaskWidget({
    super.key,
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
    _textEditingController = TextEditingController(text: widget.task.text);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _textEditingController.text = widget.task.text??"";
    return SizeTransition(
      sizeFactor: widget.animation,
      child: SizedBox(
        height: 28,
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
                    setState(() {
                      widget.task.isDone = value!;
                    });
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
                    if (_isEditable) {
                      setState(() { _isEditable = false; });
                    }
                  },
                ),
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