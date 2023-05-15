import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';


class TextStyles {
  static const _regular   = FontWeight.w400;
  static const _medium    = FontWeight.w500;
  static const _semiBold  = FontWeight.w600;
  static const _bold      = FontWeight.w700;

  static const titleBig = TextStyle(fontSize: 28, fontWeight: _bold );
  static const titleLarge = TextStyle(fontSize: 24, fontWeight: _bold );
  static const titleMedium = TextStyle(fontSize: 20, fontWeight: _bold);
  static const titleSmall = TextStyle(fontSize: 16, fontWeight: _bold);

  static const bodyLarge = TextStyle(fontSize: 16);
  static const bodyMedium = TextStyle(fontSize: 12);
  static const bodySmall = TextStyle(fontSize: 10);


  static const hintTextStyle = TextStyle(fontSize: 12, color: ColorStyles.lightGrey);
  static const tagTextStyle = TextStyle(fontSize: 14, leadingDistribution: TextLeadingDistribution.even, fontWeight: _bold);
  static const taskTextStyle = TextStyle(fontSize: 12, leadingDistribution: TextLeadingDistribution.even, fontWeight: _bold, );
}