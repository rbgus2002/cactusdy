import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';


class AppTheme {
  static final ThemeData themeData = ThemeData(
      fontFamily: TextStyles.mainFont,
      textTheme: TextStyles.textTheme,

      primaryColor: ColorStyles.mainColor,
      colorScheme: ColorStyles.colorScheme,
      appBarTheme: ColorStyles.appBarTheme,
      scaffoldBackgroundColor: ColorStyles.backgroundColor,
      focusColor: Colors.transparent,

      elevatedButtonTheme: _elevatedButtonThemeData,
      outlinedButtonTheme: _outlinedButtonThemeData,
      textButtonTheme: _textButtonThemeData,
      popupMenuTheme: _popupMenuThemeData,

      extensions: const [
        ExtraColors.extraColors,
      ]
  );

  static final ThemeData darkThemeData = ThemeData(
      fontFamily: TextStyles.mainFont,
      textTheme: TextStyles.textTheme,

      primaryColor: ColorStyles.mainColor,
      colorScheme: ColorStyles.darkColorScheme,
      appBarTheme: ColorStyles.appBarDarkTheme,
      scaffoldBackgroundColor: ColorStyles.backgroundColorDark,
      focusColor: Colors.transparent,

      elevatedButtonTheme: _elevatedButtonThemeData,
      outlinedButtonTheme: _outlinedButtonThemeData,
      textButtonTheme: _textButtonThemeData,
      popupMenuTheme: _popupMenuThemeData,

      extensions: const [
        ExtraColors.extraColorsDark,
      ]
  );

  static final ElevatedButtonThemeData _elevatedButtonThemeData = ElevatedButtonThemeData(
     style: ElevatedButton.styleFrom(
       elevation: 0,
       padding: Design.buttonPadding,
       shape: const RoundedRectangleBorder(
           borderRadius: Design.borderRadius),)
  );

  static final OutlinedButtonThemeData _outlinedButtonThemeData = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: Design.buttonPadding,
        shape: const RoundedRectangleBorder(
            borderRadius: Design.borderRadius),)
  );

  static final TextButtonThemeData _textButtonThemeData = TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: ColorStyles.mainColor,
        textStyle: TextStyles.head5,)
  );

  static const PopupMenuThemeData _popupMenuThemeData = PopupMenuThemeData(
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: Design.borderRadiusBig,),
  );
}