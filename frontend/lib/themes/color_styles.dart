
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';

class ColorStyles {
  ColorStyles._();

  /// [mainColor] & [secondColor]
  static const Color mainColor    = Color(0xFF04C781);
  static const Color secondColor  = Color(0xFF212C43);

  static const Color errorColor = Color(0xFFFF4747);
  static const Color dimDark    = Color(0xB3000000);  // opacity 70% : B3
  static const Color dim        = Color(0xB3191F28);  // opacity 70% : B3

  /// Color chip for light mode
  static const Color _blue         = Color(0xFFE3F1FF);
  static const Color _mint         = Color(0xFFDEF3F3);
  static const Color _green        = Color(0xFFEAF6E5);
  static const Color _purple       = Color(0xFFF3E8FD);
  static const Color _pink         = Color(0xFFFFE5F7);

  /// Color chip for dark mode
  static const Color _blueDark     = Color(0xFF1E4286);
  static const Color _mintDark     = Color(0xFF095959);
  static const Color _greenDark    = Color(0xFF325122);
  static const Color _purpleDark   = Color(0xFF5A3286);
  static const Color _pinkDark     = Color(0xFF6C3D5F);
  
  /// Grey scale for light mode
  static const Color _black900 = Color(0xFF191F28);
  static const Color _black800 = Color(0xFF333D4B);
  static const Color _black700 = Color(0xFF4E5968);
  static const Color _black600 = Color(0xFF6B7684);
  static const Color _black500 = Color(0xFF8B95A1);
  static const Color _black400 = Color(0xFFB9C1C9);
  static const Color _black300 = Color(0xFFD1D6DB);
  static const Color _black200 = Color(0xFFE5E8EB);
  static const Color _black100 = Color(0xFFF2F4F6);
  static const Color _black50  = Color(0xFFF7F9FB);
  static const Color _black000 = Color(0xFFFFFFFF);

  static const Color backgroundColor = _black000;

  /// Grey scale for dark mode
  static const Color _white900 = Color(0xFFFFFFFF);
  static const Color _white800 = Color(0xFFE4E4E5);
  static const Color _white700 = Color(0xFFC3C3C6);
  static const Color _white600 = Color(0xFF9E9EA4);
  static const Color _white500 = Color(0xFF7E7E87);
  static const Color _white400 = Color(0xFF4D4D59);
  static const Color _white300 = Color(0xFF4D4D59);
  static const Color _white200 = Color(0xFF3C3C47);
  static const Color _white100 = Color(0xFF25252D);
  static const Color _white50  = Color(0xFF202027);
  static const Color _white000 = Color(0xFF1C1C22);

  static const Color backgroundColorDark = _white000;

  /// Background colors for input field
  static const Color _inputFieldBackground      = Color(0xFFF3F7FF);
  static const Color _inputFieldDarkBackground  = Color(0xFF2B3147);
  static const Color _fillErrorBackground       = Color(0x19FF4747);

  /// Button colors
  static const Color _disabledPrimaryButtonColor = Color(0x4D04C781); // opacity 30% : 4D

  static const List<Color> studyColors = [
    Color(0xFFFFC600),
    Color(0xFFFF9F47),
    Color(0xFFFF740F),
    Color(0xFFFFABCE),
    Color(0xFFFF8989),
    Color(0xFFFF6060),

    Color(0xFFFF6AB2),
    Color(0xFFEA67FF),
    Color(0xFFAF70FF),
    Color(0xFF8987FF),
    Color(0xFF5760B1),
    Color(0xFF1C2043),

    Color(0xFF52DE71),
    Color(0xFF00E0B8),
    Color(0xFF63D7A6),
    Color(0xFF20D2D2),
    Color(0xFF5ECCC5),
    Color(0xFF4D9F5F),

    Color(0xFFA6DAFF),
    Color(0xFF6CBFEE),
    Color(0xFF70A0FF),
    Color(0xFF41BBFF),
    Color(0xFF4B5DFF),
    Color(0xFF2C3798),
  ];



  static const ColorScheme colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: mainColor,
      onPrimary: Colors.white,
      secondary: secondColor,
      onSecondary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      background: Colors.red, //< FIXME : idk it used in
      onBackground: _black800,
      surface: _black000,
      onSurface: _black800,
  );

  static const ColorScheme darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: mainColor,
      onPrimary: Colors.white,
      secondary: secondColor,
      onSecondary: Colors.white,
      error: errorColor,
      onError: Colors.white,
      background: Colors.red, //< FIXME : idk it used in
      onBackground: _white800,
      surface: _white50,
      onSurface: _white800,
  );

  static final AppBarTheme appBarTheme = AppBarTheme(
    elevation: 0,
    color: backgroundColor,
    titleTextStyle: TextStyles.head4.copyWith(color: _black800),
    foregroundColor: _black900,
    systemOverlayStyle: SystemUiOverlayStyle.dark,
    shape: const Border(bottom: BorderSide(color: _black200)),
  );

  static final AppBarTheme appBarDarkTheme = AppBarTheme(
    elevation: 0,
    color: backgroundColorDark,
    titleTextStyle: TextStyles.head4.copyWith(color: _white800),
    foregroundColor: _white800,
    systemOverlayStyle: SystemUiOverlayStyle.light,
    shape: const Border(bottom: BorderSide(color: _white200)),
  );

  static final ElevatedButtonThemeData elevatedButtonThemeData = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: Design.buttonPadding,
        disabledBackgroundColor: _disabledPrimaryButtonColor,
        disabledForegroundColor: _black000,
        shape: const RoundedRectangleBorder(
            borderRadius: Design.borderRadius),)
  );

  static final ElevatedButtonThemeData elevatedButtonDarkThemeData = ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: Design.buttonPadding,
        disabledBackgroundColor: _disabledPrimaryButtonColor,
        disabledForegroundColor: _white000,
        shape: const RoundedRectangleBorder(
            borderRadius: Design.borderRadius),)
  );


  static final OutlinedButtonThemeData outlinedButtonThemeData = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: Design.buttonPadding,
        foregroundColor: _black900,
        disabledForegroundColor: _black300,
        shape: const RoundedRectangleBorder(
            borderRadius: Design.borderRadius),)
  );


  static final OutlinedButtonThemeData outlinedButtonDarkThemeData = OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        padding: Design.buttonPadding,
        foregroundColor: _white900,
        disabledForegroundColor: _white300,
        shape: const RoundedRectangleBorder(
            borderRadius: Design.borderRadius),)
  );
}

class ExtraColors extends ThemeExtension<ExtraColors> {
  /// Color chip
  final Color? blue;
  final Color? mint;
  final Color? green;
  final Color? purple;
  final Color? pink;

  /// Grey scale
  final Color? grey900;
  final Color? grey800;
  final Color? grey700;
  final Color? grey600;
  final Color? grey500;
  final Color? grey400;
  final Color? grey300;
  final Color? grey200;
  final Color? grey100;
  final Color? grey50;
  final Color? grey000;

  /// Button colors
  final Color? primaryButtonColor;
  final Color? secondButtonColor;
  final Color? disabledPrimaryButtonColor;
  final Color? disabledSecondButtonColor;

  /// Input field colors
  final Color? inputFieldBackgroundColor;
  final Color? inputFieldBackgroundErrorColor;

  /// Base background Color
  final Color? baseBackgroundColor;

  /// Barrier Color
  final Color? barrierColor;

  const ExtraColors({
    required this.blue,
    required this.mint,
    required this.green,
    required this.purple,
    required this.pink,

    required this.grey900,
    required this.grey800,
    required this.grey700,
    required this.grey600,
    required this.grey500,
    required this.grey400,
    required this.grey300,
    required this.grey200,
    required this.grey100,
    required this.grey50,
    required this.grey000,

    required this.primaryButtonColor,
    required this.secondButtonColor,
    required this.disabledPrimaryButtonColor,
    required this.disabledSecondButtonColor,

    required this.inputFieldBackgroundColor,
    required this.inputFieldBackgroundErrorColor,

    required this.baseBackgroundColor,
    required this.barrierColor,
  });

  @override
  ExtraColors copyWith({
    Color? blue,
    Color? mint,
    Color? green,
    Color? purple,
    Color? pink,

    Color? grey900,
    Color? grey800,
    Color? grey700,
    Color? grey600,
    Color? grey500,
    Color? grey400,
    Color? grey300,
    Color? grey200,
    Color? grey100,
    Color? grey50,
    Color? grey000,
    
    Color? primaryButtonColor,
    Color? secondButtonColor,
    Color? disabledPrimaryButtonColor,
    Color? disabledSecondButtonColor,

    Color? inputFieldBackgroundColor,
    Color? inputFieldBackgroundErrorColor,

    Color? baseBackgroundColor,
    Color? reservedTagColor,
    Color? barrierColor,
  }) {
    return ExtraColors(
        blue: blue?? this.blue,
        mint: mint?? this.mint,
        green: green?? this.green,
        purple: purple?? this.purple,
        pink: pink?? this.pink,

        grey900: grey900?? this.grey900,
        grey800: grey800?? this.grey800,
        grey700: grey700?? this.grey700,
        grey600: grey600?? this.grey600,
        grey500: grey500?? this.grey500,
        grey400: grey400?? this.grey400,
        grey300: grey300?? this.grey300,
        grey200: grey200?? this.grey200,
        grey100: grey100?? this.grey100,
        grey50:  grey50??  this.grey50,
        grey000: grey000?? this.grey000,

        primaryButtonColor: primaryButtonColor?? this.primaryButtonColor,
        secondButtonColor: secondButtonColor?? this.secondButtonColor,
        disabledPrimaryButtonColor: disabledPrimaryButtonColor?? this.disabledPrimaryButtonColor,
        disabledSecondButtonColor: disabledSecondButtonColor?? this.disabledSecondButtonColor,

        inputFieldBackgroundColor: inputFieldBackgroundColor?? this.inputFieldBackgroundColor,
        inputFieldBackgroundErrorColor: inputFieldBackgroundErrorColor?? this.inputFieldBackgroundErrorColor,

        baseBackgroundColor: baseBackgroundColor?? this.baseBackgroundColor,
        barrierColor: barrierColor?? this.barrierColor,
    );
  }

  @override
  ExtraColors lerp(ThemeExtension<ExtraColors>? other, double t) {
    if (other is! ExtraColors) {
      return this;
    }
    return ExtraColors(
      blue: Color.lerp(blue, other.blue, t),
      mint: Color.lerp(mint, other.mint, t),
      green: Color.lerp(green, other.green, t),
      purple: Color.lerp(purple, other.purple, t),
      pink: Color.lerp(pink, other.pink, t),

      grey900: Color.lerp(grey900, other.grey900, t),
      grey800: Color.lerp(grey800, other.grey800, t),
      grey700: Color.lerp(grey700, other.grey700, t),
      grey600: Color.lerp(grey600, other.grey600, t),
      grey500: Color.lerp(grey500, other.grey500, t),
      grey400: Color.lerp(grey400, other.grey400, t),
      grey300: Color.lerp(grey300, other.grey300, t),
      grey200: Color.lerp(grey200, other.grey200, t),
      grey100: Color.lerp(grey100, other.grey100, t),
      grey50: Color.lerp(grey50, other.grey50, t),
      grey000: Color.lerp(grey000, other.grey000, t),

      primaryButtonColor: Color.lerp(primaryButtonColor, other.primaryButtonColor, t),
      secondButtonColor: Color.lerp(secondButtonColor, other.secondButtonColor, t),
      disabledPrimaryButtonColor: Color.lerp(disabledPrimaryButtonColor, other.disabledPrimaryButtonColor, t),
      disabledSecondButtonColor: Color.lerp(disabledSecondButtonColor, disabledSecondButtonColor, t),

      inputFieldBackgroundColor: Color.lerp(inputFieldBackgroundColor, other.inputFieldBackgroundColor, t),
      inputFieldBackgroundErrorColor: Color.lerp(inputFieldBackgroundErrorColor, other.inputFieldBackgroundErrorColor, t),

      baseBackgroundColor: Color.lerp(baseBackgroundColor, other.baseBackgroundColor, t),
      barrierColor: Color.lerp(barrierColor, other.barrierColor, t),
    );
  }

  static const ExtraColors extraColors = ExtraColors(
      blue: ColorStyles._blue,
      mint: ColorStyles._mint,
      green: ColorStyles._green,
      purple: ColorStyles._purple,
      pink: ColorStyles._pink,

      grey900: ColorStyles._black900,
      grey800: ColorStyles._black800,
      grey700: ColorStyles._black700,
      grey600: ColorStyles._black600,
      grey500: ColorStyles._black500,
      grey400: ColorStyles._black400,
      grey300: ColorStyles._black300,
      grey200: ColorStyles._black200,
      grey100: ColorStyles._black100,
      grey50:  ColorStyles._black50,
      grey000: ColorStyles._black000,

      primaryButtonColor: ColorStyles.mainColor,
      secondButtonColor: ColorStyles.secondColor,
      disabledPrimaryButtonColor: ColorStyles._disabledPrimaryButtonColor,
      disabledSecondButtonColor: ColorStyles._black300,

      inputFieldBackgroundColor: ColorStyles._inputFieldBackground,
      inputFieldBackgroundErrorColor: ColorStyles._fillErrorBackground,

      baseBackgroundColor: ColorStyles._black100,
      barrierColor: ColorStyles.dim,
  );

  static const ExtraColors extraColorsDark = ExtraColors(
      blue: ColorStyles._blueDark,
      mint: ColorStyles._mintDark,
      green: ColorStyles._greenDark,
      purple: ColorStyles._purpleDark,
      pink: ColorStyles._pinkDark,

      grey900: ColorStyles._white900,
      grey800: ColorStyles._white800,
      grey700: ColorStyles._white700,
      grey600: ColorStyles._white600,
      grey500: ColorStyles._white500,
      grey400: ColorStyles._white400,
      grey300: ColorStyles._white300,
      grey200: ColorStyles._white200,
      grey100: ColorStyles._white100,
      grey50:  ColorStyles._white50,
      grey000: ColorStyles._white000,

      primaryButtonColor: ColorStyles.mainColor,
      secondButtonColor: ColorStyles.mainColor,
      disabledPrimaryButtonColor: ColorStyles._white300,
      disabledSecondButtonColor: ColorStyles._white300,

      inputFieldBackgroundColor: ColorStyles._inputFieldDarkBackground,
      inputFieldBackgroundErrorColor: ColorStyles._fillErrorBackground,

      baseBackgroundColor: Colors.black,
      barrierColor: ColorStyles.dimDark,
  );
}