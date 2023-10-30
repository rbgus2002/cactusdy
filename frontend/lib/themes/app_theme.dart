import 'package:flutter/material.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_text_styles.dart';

class AppTheme {
  //< FIXME : not completed
  static ThemeData themeData(ColorScheme colorScheme, Color focusColor) {
    return ThemeData(
      colorScheme: colorScheme,
      textTheme: _textTheme,
    );
  }
/*
  static const ColorScheme lightColorScheme = ColorScheme(
    error: ColorStyles.lightGrey,
  );
*/
  static const TextTheme _textTheme = TextTheme(
    titleLarge: OldTextStyles.hintTextStyle,

  );
}