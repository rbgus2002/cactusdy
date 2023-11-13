

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';

class AddButton extends StatelessWidget {
  static const double _iconSize = 16;

  final IconData iconData;
  final String text;
  final VoidCallback onTap;

  const AddButton({
    Key? key,
    required this.iconData,
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
            iconData,
            color: context.extraColors.grey500,
            size: _iconSize),

          Design.padding4,

          Text(
            text,
            style: TextStyles.caption1.copyWith(
                color: context.extraColors.grey500)),
        ],
      )
    );
  }
}