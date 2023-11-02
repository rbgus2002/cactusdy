import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
import 'package:group_study_app/themes/text_styles.dart';


class AppTheme {
  static final ThemeData themeData = ThemeData(
      fontFamily: TextStyles.mainFont,

      scaffoldBackgroundColor: ColorStyles.backgroundColor,

      colorScheme: ColorStyles.colorScheme,
      buttonTheme: _buttonTheme,
      elevatedButtonTheme: _elevatedButtonThemeData,
      outlinedButtonTheme: _outlinedButtonThemeData,
      textTheme: TextStyles.textTheme,
      extensions: const [
        AdditionalColor.additionalColor,
      ]
      //inputDecorationTheme: _inputDecorationTheme,
    );

  static final ThemeData darkThemeData = ThemeData(
      fontFamily: TextStyles.mainFont,

      scaffoldBackgroundColor: ColorStyles.backgroundColorDark,

      colorScheme: ColorStyles.darkColorScheme,
      buttonTheme: _buttonTheme,
      elevatedButtonTheme: _elevatedButtonThemeData,
      outlinedButtonTheme: _outlinedButtonThemeData,
      textTheme: TextStyles.textTheme,
      extensions: const [
        AdditionalColor.additionalColorDark,
      ]
  );

  static final ElevatedButtonThemeData _elevatedButtonThemeData = ElevatedButtonThemeData(
     style: ElevatedButton.styleFrom(
       elevation: 0,
       padding: Design.buttonPadding,
       shape: const RoundedRectangleBorder(
           borderRadius: Design.borderRadius),
     )
  );

  static final OutlinedButtonThemeData _outlinedButtonThemeData = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: Design.buttonPadding,
        shape: const RoundedRectangleBorder(
            borderRadius: Design.borderRadius),
      )
  );

  static const ButtonThemeData _buttonTheme = ButtonThemeData(
    buttonColor: ColorStyles.mainColor,
  );
}