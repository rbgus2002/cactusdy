import 'package:flutter/material.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/widgets/Tags/tag_button.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';

class StudyGroupTag extends TagButton {
  static const studyTagPadding = EdgeInsets.fromLTRB(2, 2, 10, 2);
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
          const CircleButton(scale:16, onTap: null, url: '',), //< FIXME
          OldDesign.padding5,
          Text(name, style: OldTextStyles.tagTextStyle, textAlign: TextAlign.center),
        ],)
  );
}