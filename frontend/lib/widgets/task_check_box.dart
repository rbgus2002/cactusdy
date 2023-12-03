import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/utilities/animation_setting.dart';
import 'package:group_study_app/utilities/extensions.dart';

class TaskCheckBox extends StatefulWidget {
  final Task task;
  final VoidCallback onChanged;

  final Color? activeColor;
  final Color? fillColor;

  final double size;
  final bool enable;

  const TaskCheckBox({
    Key? key,
    required this.task,
    required this.onChanged,

    this.activeColor,
    this.fillColor,

    this.size = 24,
    this.enable = true,
  }) : super(key: key);

  @override
  State<TaskCheckBox> createState() => _TaskCheckBoxState();
}

class _TaskCheckBoxState extends State<TaskCheckBox> {
  static const double _iconSize = 14;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(widget.size),
      onTap: (widget.enable)? widget.onChanged : null,
      child: AnimatedContainer(
        width: widget.size,
        height: widget.size,
        curve: Curves.easeOutCubic,
        alignment: Alignment.center,
        duration: (widget.task.isDone)?
          AnimationSetting.animationDurationShort :
          Duration.zero,
        decoration: BoxDecoration(
          color: (widget.task.isDone)?
            widget.activeColor??ColorStyles.mainColor :
            widget.fillColor??context.extraColors.grey300,
          borderRadius: BorderRadius.circular(widget.size),),
        child: (widget.task.isDone)?
            Icon(
              CustomIcons.check2,
              color: context.extraColors.grey000,
              size: _iconSize) : null,),
    );
  }
}