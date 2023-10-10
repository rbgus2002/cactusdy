import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';


class TextStyles {
  static const regular   = FontWeight.w400;
  static const medium    = FontWeight.w500;
  static const semiBold  = FontWeight.w600;
  static const bold      = FontWeight.w700;
  static const extraBold = FontWeight.w800;

  static const titleBig = TextStyle(fontSize: 28, fontWeight: extraBold);
  static const titleLarge = TextStyle(fontSize: 24, fontWeight: extraBold);
  static const titleMedium = TextStyle(fontSize: 20, fontWeight: extraBold);
  static const titleSmall = TextStyle(fontSize: 18, fontWeight: extraBold);
  static const titleTiny = TextStyle(fontSize: 16, fontWeight: bold);

  static const bodyLarge = TextStyle(fontSize: 16, height: 1.5);
  static const bodyMedium = TextStyle(fontSize: 14, height: 1.5);
  static const bodySmall = TextStyle(fontSize: 12, height: 1.5);

  static const numberTextStyle = TextStyle(fontSize: 32, fontWeight: extraBold, height: 0);

  static const hintTextStyle = TextStyle(fontSize: 12, color: ColorStyles.lightGrey);
  static const tagTextStyle = TextStyle(fontSize: 12, leadingDistribution: TextLeadingDistribution.even, fontWeight: bold, color: Colors.white);

  static const taskTextStyle = TextStyle(fontSize: 14, fontWeight: medium, height: 1, color: ColorStyles.taskTextColor);

  static const roundTextStyle = TextStyle(fontSize: 14, fontWeight: semiBold, height: 1, color: ColorStyles.taskTextColor);
  static const roundHintTextStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.normal, height: 1, color: ColorStyles.taskHintTextColor);


  static const wideTextStyle = TextStyle(fontSize: 16, fontWeight: semiBold, letterSpacing: 2);

  static const errorTextStyle = TextStyle(fontSize: 12, color: ColorStyles.errorColor);
}