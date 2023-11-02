import 'package:flutter/material.dart';

class Design {
  static const double targetWidth = 512;

  static const double borderRadiusValueSmall = 4.0;
  static const double borderRadiusValue = 8.0;

  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(borderRadiusValueSmall));
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(borderRadiusValue));

  static const EdgeInsets buttonPadding = EdgeInsets.fromLTRB(20, 10, 20, 10);
  static const double buttonContentHeight = 32.0;
  
  static const EdgeInsets toastPadding = EdgeInsets.fromLTRB(16, 10, 16, 10);
  static const double toastHeight = 44.0;

  static const EdgeInsets edge4 = EdgeInsets.all(4.0);
  static const EdgeInsets edge8 = EdgeInsets.all(8.0);
}