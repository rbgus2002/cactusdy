import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';


class TextStyles {
  static const _regular   = FontWeight.w400;
  static const _medium    = FontWeight.w500;
  static const _semiBold  = FontWeight.w600;
  static const _bold      = FontWeight.w700;

  // ex)
  static const hintTextStyle = TextStyle(fontSize: 12, color: ColorStyles.lightGrey);

  static const titleLarge = TextStyle(fontSize: 32, fontWeight: _bold );
  static const titleMedium = TextStyle(fontSize: 28, fontWeight: _bold);
  static const titleSmall = TextStyle(fontSize: 24, fontWeight: _bold);

  static const bodyLarge = TextStyle(fontSize: 20);
  static const bodyMedium = TextStyle(fontSize: 16);
  static const bodySmall = TextStyle(fontSize: 12);
}