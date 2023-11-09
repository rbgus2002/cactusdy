

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';

class AddButton extends StatelessWidget {
  static const double _iconSize = 16;

  final Color? color;
  final String text;
  final VoidCallback onTap;

  const AddButton({
    Key? key,
    this.color,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            CustomIcons.plus_square,
            color: color,
            size: _iconSize),

          Design.padding4,

          Text(
            text,
            style: TextStyles.caption1.copyWith(color: color)),
        ],
      )
    );
  }
}