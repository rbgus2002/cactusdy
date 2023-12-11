
import 'package:flutter/material.dart';

class TextStyles {
  static const String mainFont = 'Pretendard';

  static const regular    = FontWeight.w400;
  static const medium     = FontWeight.w500;
  static const semiBold   = FontWeight.w600;
  static const bold       = FontWeight.w700;
  static const extraBold  = FontWeight.w800;
  static const black      = FontWeight.w900;

  //static const double letterSpacingFactor = -0.02;  // -2%
  static const TextStyle head1 = TextStyle(fontSize: 32, letterSpacing: -0.64, height: 1.1875, fontWeight: bold);
  static const TextStyle head2 = TextStyle(fontSize: 24, letterSpacing: -0.48, height: 1.25, fontWeight: bold);
  static const TextStyle head3 = TextStyle(fontSize: 21, letterSpacing: -0.42, height: 1.2381, fontWeight: bold);
  static const TextStyle head4 = TextStyle(fontSize: 18, letterSpacing: -0.36, height: 1.2222, fontWeight: semiBold);
  static const TextStyle head5 = TextStyle(fontSize: 16, letterSpacing: -0.32, height: 1.25, fontWeight: semiBold);
  static const TextStyle head6 = TextStyle(fontSize: 14, letterSpacing: -0.28, height: 1.2857, fontWeight: bold);

  static const TextStyle body1 = TextStyle(fontSize: 16, letterSpacing: -0.32, height: 1.25, fontWeight: medium);
  static const TextStyle body2 = TextStyle(fontSize: 14, letterSpacing: -0.28, height: 1.2857, fontWeight: regular);
  static const TextStyle body3 = TextStyle(fontSize: 13, letterSpacing: -0.26, height: 1.2308, fontWeight: regular);
  static const TextStyle body4 = TextStyle(fontSize: 12, letterSpacing: -0.24, height: 1.1667, fontWeight: regular);

  static const TextStyle caption1 = TextStyle(fontSize: 14, letterSpacing: -0.28, height: 1.2857, fontWeight: semiBold);
  static const TextStyle caption2 = TextStyle(fontSize: 12, letterSpacing: -0.22, height: 1.1667, fontWeight: semiBold);

  static const TextStyle startTitle = TextStyle(fontSize: 28, letterSpacing: -0.48, height: 1.4286, fontWeight: bold);
  static const TextStyle task = TextStyle(fontSize: 15, letterSpacing: -0.45, fontWeight: semiBold);

  static const TextTheme textTheme = TextTheme(
    displayLarge: head1,
    displayMedium: head2,
    displaySmall: head3,
    headlineLarge: head4,
    headlineMedium: head5,
    headlineSmall: head6,

    bodyLarge: body1,
    bodyMedium: body2,
    bodySmall: body3,

    titleSmall: head4,
  );
}