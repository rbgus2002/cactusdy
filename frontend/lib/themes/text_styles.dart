
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
  static const TextStyle head1 = TextStyle(fontSize: 32, letterSpacing: -0.64, fontWeight: bold);
  static const TextStyle head2 = TextStyle(fontSize: 24, letterSpacing: -0.48, fontWeight: bold);
  static const TextStyle head3 = TextStyle(fontSize: 21, letterSpacing: -0.42, fontWeight: bold);
  static const TextStyle head4 = TextStyle(fontSize: 18, letterSpacing: -0.36, fontWeight: semiBold);
  static const TextStyle head5 = TextStyle(fontSize: 16, letterSpacing: -0.32, fontWeight: semiBold);
  static const TextStyle head6 = TextStyle(fontSize: 14, letterSpacing: -0.28, fontWeight: bold);

  static const TextStyle body1 = TextStyle(fontSize: 16, letterSpacing: -0.32, fontWeight: medium);
  static const TextStyle body2 = TextStyle(fontSize: 14, letterSpacing: -0.28, fontWeight: regular);
  static const TextStyle body3 = TextStyle(fontSize: 13, letterSpacing: -0.26, fontWeight: regular);
  static const TextStyle body4 = TextStyle(fontSize: 12, letterSpacing: -0.24, fontWeight: regular);

  static const TextStyle caption1 = TextStyle(fontSize: 14, letterSpacing: -0.28, fontWeight: semiBold);
  static const TextStyle caption2 = TextStyle(fontSize: 11, letterSpacing: -0.22, fontWeight: medium);

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
  );
}