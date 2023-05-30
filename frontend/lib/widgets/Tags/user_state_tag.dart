import 'package:flutter/material.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/Tags/tag.dart';

class UserStateTag extends TagButton {
  static const userStateTagPadding = EdgeInsets.fromLTRB(10, 0, 10, 0);
  String text;

  UserStateTag({
    this.text = "",
    super.key,
    super.color,
    super.onTap }) : super(
    padding: userStateTagPadding,
    child: Text(text, textWidthBasis: TextWidthBasis.parent,
      style: TextStyles.tagTextStyle, textAlign: TextAlign.center,),
  );
}
