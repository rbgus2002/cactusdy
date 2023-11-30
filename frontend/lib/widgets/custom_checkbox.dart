import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/utilities/animation_setting.dart';
import 'package:group_study_app/utilities/extensions.dart';

class CustomCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  final Color? activeColor;
  final Color? fillColor;

  final double size;

  const CustomCheckBox({
    Key? key,
    required this.value,
    required this.onChanged,

    this.activeColor,
    this.fillColor,

    this.size = 24,
  }) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  static const double _iconSize = 14;
  bool _value = false;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(widget.size),
      child: AnimatedContainer(
          width: widget.size,
          height: widget.size,
          duration: AnimationSetting.animationDurationShort,
          curve: Curves.easeOutCubic,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: (_value)?
              widget.activeColor??ColorStyles.mainColor :
              widget.fillColor??context.extraColors.grey300,
            borderRadius: BorderRadius.circular(widget.size),),
          child: (_value)?
              Icon(
                CustomIcons.check2,
                color: context.extraColors.grey000,
                size: _iconSize) : null,
        ),
      onTap: () {
        setState(() => _value = !_value);
        widget.onChanged(_value);
      },
    );
  }
}