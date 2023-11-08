
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';

class TaskListTitle extends StatelessWidget {
  static const EdgeInsets _padding = EdgeInsets.symmetric(vertical: 8, horizontal: 12);

  final String title;
  final VoidCallback onTap;

  const TaskListTitle({
    Key? key,
    required this.title,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final additionalColor = Theme.of(context).extension<AdditionalColor>()!;

    return InkWell(
      borderRadius: Design.borderRadiusSmall,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: Design.borderRadiusSmall,
          color: additionalColor.grey100,
        ),
        padding: _padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
            children : [
              Text(title, style: TextStyles.head5.copyWith(color: additionalColor.grey600),),
              Design.padding8,
              Container(
                decoration: BoxDecoration(
                  borderRadius: Design.borderRadiusSmall,
                  color: additionalColor.grey000,
                ),
                child: Icon(Icons.add, color: additionalColor.grey600,)
              ),
            ]),
      ),
    );
  }
}