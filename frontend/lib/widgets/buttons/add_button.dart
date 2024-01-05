

import 'package:flutter/material.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';

class AddButton extends StatelessWidget {
  static const double _iconSize = 16;

  final IconData iconData;
  final String text;
  final VoidCallback onTap;

  const AddButton({
    super.key,
    required this.iconData,
    required this.text,
    required this.onTap,
  });

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