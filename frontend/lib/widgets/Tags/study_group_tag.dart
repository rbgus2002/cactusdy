import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/Tags/tag.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';

class StudyGroupTag extends TagButton {
  static const studyTagPadding = EdgeInsets.fromLTRB(3, 3, 10, 3);
  Image? image;
  String name;

  StudyGroupTag({
    this.image,
    this.name = "",
    super.key,
    super.color,
    super.onTap }) : super(
      padding: studyTagPadding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,

        children: [
          const CircleButton(scale:20, onTap: null),
          Design.padding5,
          Text(name, style: TextStyles.tagTextStyle, textAlign: TextAlign.center),
        ],)
  );
}