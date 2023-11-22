

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';

class TextCounter extends StatelessWidget {
  final int length;
  final int maxLength;

  const TextCounter({
    Key? key,
    required this.length,
    required this.maxLength,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Design.padding4,
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
                '$length',
                style: TextStyles.body2.copyWith(color: ColorStyles.mainColor)),
            Text(
              '/$maxLength',
              style: TextStyles.body2.copyWith(color: context.extraColors.grey400),),
          ],),
      ],
    );
  }
}