import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';

class TitleWidget extends StatelessWidget {
  final String title;
  final Icon icon;
  final double? iconSize;
  final Function? onTap;

  const TitleWidget({
    Key? key,
    required this.title,
    required this.icon,
    this.iconSize,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Flexible(fit: FlexFit.tight,child: Text(title, style: TextStyles.titleSmall),),
        IconButton(
          icon: icon,
          splashRadius: 16,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          onPressed: () {
            if (onTap != null) { onTap!(); }
          }
        ),
      ],
    );
  }
}