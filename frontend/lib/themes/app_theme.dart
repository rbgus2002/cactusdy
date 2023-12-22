import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';

extension ThemeModeStringExtension on ThemeMode {
  static const String _light = 'light';
  static const String _dark = 'dark';
  static const String _system = 'system';

  static const Map<String, ThemeMode> themes = {
    _light: ThemeMode.light,
    _dark: ThemeMode.dark,
    _system: ThemeMode.system,
  };

  String toStr() {
    switch(this) {
      case ThemeMode.light:
        return _light;
      case ThemeMode.dark:
        return _dark;
      case ThemeMode.system:
        return _system;
    }
  }
}

class AppTheme with ChangeNotifier {
  AppTheme._();

  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _themeKey = 'theme';

  static void init() {
    _readThemeSetting();
  }

  static void setTheme(ThemeMode newThemeMode) {
    themeMode.value = newThemeMode;
    _saveThemeSetting();
  }

  static void _readThemeSetting() async {
    String? themeStr = await _storage.read(key: _themeKey);

    if (themeStr != null) {
      themeMode.value = ThemeModeStringExtension.themes[themeStr]??ThemeMode.system;
    }
  }

  static void _saveThemeSetting() async {
    await _storage.write(
        key: _themeKey,
        value: themeMode.value.toStr());
  }

  static final ThemeData themeData = ThemeData(
      fontFamily: TextStyles.mainFont,
      textTheme: TextStyles.textTheme,

      primaryColor: ColorStyles.mainColor,
      colorScheme: ColorStyles.colorScheme,
      appBarTheme: ColorStyles.appBarTheme,
      scaffoldBackgroundColor: ColorStyles.backgroundColor,
      focusColor: Colors.transparent,

      elevatedButtonTheme: ColorStyles.elevatedButtonThemeData,
      outlinedButtonTheme: ColorStyles.outlinedButtonThemeData,
      textButtonTheme: _textButtonThemeData,
      popupMenuTheme: _popupMenuThemeData,
      datePickerTheme: _datePickerThemeData,
      expansionTileTheme: _expansionTileThemeData,
      listTileTheme: _listTileThemeData,

      pageTransitionsTheme: _pageTransitionsTheme,

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

      elevatedButtonTheme: ColorStyles.elevatedButtonDarkThemeData,
      outlinedButtonTheme: ColorStyles.outlinedButtonDarkThemeData,
      textButtonTheme: _textButtonThemeData,
      popupMenuTheme: _popupMenuThemeData,
      datePickerTheme: _datePickerThemeData,
      expansionTileTheme: _expansionTileThemeData,
      listTileTheme: _listTileThemeData,

      pageTransitionsTheme: _pageTransitionsTheme,

      extensions: const [
        ExtraColors.extraColorsDark,
      ]
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

  static const DatePickerThemeData _datePickerThemeData = DatePickerThemeData(
    weekdayStyle: TextStyles.body2,
    dayStyle: TextStyles.head3,
    yearStyle: TextStyles.head4,
  );

  static const ExpansionTileThemeData _expansionTileThemeData = ExpansionTileThemeData(
    shape: InputBorder.none,
    collapsedShape: InputBorder.none,
    childrenPadding: EdgeInsets.zero,
    tilePadding: EdgeInsets.zero,
  );

  static const ListTileThemeData _listTileThemeData = ListTileThemeData(
    contentPadding: EdgeInsets.zero,
    minVerticalPadding: -16,
    minLeadingWidth: 0,
    horizontalTitleGap: -16,
    dense: true,
  );

  static const PageTransitionsTheme _pageTransitionsTheme = PageTransitionsTheme(
    builders: {
      TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
      TargetPlatform.android: CupertinoPageTransitionsBuilder(),
      TargetPlatform.macOS: CupertinoPageTransitionsBuilder(),
    }
  );
}