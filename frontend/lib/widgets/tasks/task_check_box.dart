import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupstudy/models/task.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/utilities/animation_setting.dart';
import 'package:groupstudy/utilities/color_util.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/lazy_update_controller.dart';

class TaskCheckBox extends StatefulWidget {
  final Task task;

  final VoidCallback? onClick;
  final VoidCallback onUpdate;

  final Color? activeColor;
  final Color? fillColor;

  final double size;
  final bool enable;

  const TaskCheckBox({
    super.key,
    required this.task,
    required this.onUpdate,
    this.onClick,

    this.activeColor,
    this.fillColor,

    this.size = 24,
    this.enable = true,
  });

  @override
  State<TaskCheckBox> createState() => _TaskCheckBoxState();
}

class _TaskCheckBoxState extends State<TaskCheckBox> {
  late final LazyUpdateController<bool> _lazyUpdateController;
  static const double _iconSize = 14;
  static const int _waitingTime = 3; // 3 sec

  @override
  void initState() {
    super.initState();

    _lazyUpdateController = LazyUpdateController(
        initState: widget.task.isDone,
        onUpdate: widget.onUpdate);
  }

  @override
  Widget build(BuildContext context) {
    bool bright = ColorUtil.isBright(widget.activeColor??ColorStyles.mainColor);

    return InkWell(
      borderRadius: BorderRadius.circular(widget.size),
      onTap: switchState,
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
              color: (bright)?
                context.extraColors.grey000 :
                Colors.white,
              size: _iconSize) : null,),
    );
  }

  @override
  void dispose() {
    _lazyUpdateController.update();
    super.dispose();
  }

  void switchState() {
    if (widget.enable) {
      setState(() {
        HapticFeedback.lightImpact();
        widget.task.isDone = !widget.task.isDone;

        if (widget.onClick != null) {
          widget.onClick!();
        }

        _lazyUpdateController.lazyUpdate(
            widget.task.isDone, _waitingTime,);
      });
    }
  }
}