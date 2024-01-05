
import 'package:flutter/material.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';

class TaskListTitle extends StatelessWidget {
  static const EdgeInsets _padding = EdgeInsets.symmetric(vertical: 8, horizontal: 12);

  final String title;
  final VoidCallback onTap;
  final bool enable;

  const TaskListTitle({
    super.key,
    required this.title,
    required this.onTap,
    required this.enable,
  });

  @override
  Widget build(BuildContext context) {
    return (enable) ?
      InkWell(
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
        ),) :
      Container(
        padding: _padding,
        decoration: BoxDecoration(
          borderRadius: Design.borderRadiusSmall,
          color: context.extraColors.grey100,),
        child: Text(title, style: TextStyles.head5.copyWith(color: context.extraColors.grey600),),);
  }
}