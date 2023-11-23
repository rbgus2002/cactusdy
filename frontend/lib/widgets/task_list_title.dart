
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';

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
    return InkWell(
      borderRadius: Design.borderRadiusSmall,
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: Design.borderRadiusSmall,
          color: context.extraColors.grey100,
        ),
        padding: _padding,
        child: Row(
          mainAxisSize: MainAxisSize.min,
            children : [
              Text(title, style: TextStyles.head5.copyWith(color: context.extraColors.grey600),),
              Design.padding8,
              Container(
                decoration: BoxDecoration(
                  borderRadius: Design.borderRadiusSmall,
                  color: context.extraColors.grey000,
                ),
                child: Icon(Icons.add, color: context.extraColors.grey600,)
              ),
            ]),
      ),
    );
  }
}