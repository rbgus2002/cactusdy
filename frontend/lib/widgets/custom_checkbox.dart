import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/utilities/animation_setting.dart';

class CustomCheckBox extends StatefulWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  final Color? activeColor;
  final Color? fillColor;

  final double size;

  const CustomCheckBox({
    Key? key,
    this.value = false,
    required this.onChanged,

    this.activeColor,
    this.fillColor,

    this.size = 24,
  }) : super(key: key);

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> with TickerProviderStateMixin {
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
      child: Container(
          width: widget.size,
          height: widget.size,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: (_value)?
              widget.activeColor??Theme.of(context).primaryColor :
              widget.fillColor??Theme.of(context).extension<AdditionalColor>()!.grey300,
            borderRadius: BorderRadius.circular(widget.size),
          ),
          child: (_value)? Icon(CustomIcons.check, size: widget.size * 0.7) : null,
        ),
      onTap: () {
        setState(() {
          _value = !_value;
        });
      },
    );
  }
}