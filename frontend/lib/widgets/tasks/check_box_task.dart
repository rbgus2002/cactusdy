/*
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/tasks/task_widget.dart';

class CheckBoxTask extends Task {
  bool _isChecked = false;
  String? text;

  CheckBoxTask({
    super.key,
    required super.taskid,
    this.text = "",
  });

  @override
  bool isDone() {
    return false;
  }

  @override
  State<CheckBoxTask> createState() => _CheckBoxTask();
}

class _CheckBoxTask extends State<CheckBoxTask> {
  late final textEditingController = TextEditingController(text: widget.text,);
  bool _isEditable = false;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 26,
      child: GestureDetector(
        onTap: () {  setState(() { _isEditable = true; }); },
        onLongPress: Test.onTabTest,

        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,

          children: [
            SizedBox(
              width: 26,
              height: 26,
              child: Checkbox(
                //activeColor: Colors.red,
                  value: widget._isChecked,
                  onChanged: (value) { setState(() { widget._isChecked = value!; });},
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap),
            ),
            Flexible(
              fit: FlexFit.tight,
              child: TextField(
                maxLines: 1,
                style: TextStyles.taskTextStyle,

                controller: textEditingController,
                decoration: InputDecoration(
                  isDense: true,
                  disabledBorder: InputBorder.none,
                  enabled: _isEditable,
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
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }
}

 */