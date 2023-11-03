import 'package:flutter/material.dart';

class Design {
  static const double targetWidth = 512;

  static const double borderRadiusValueSmall = 4.0;
  static const double borderRadiusValue = 8.0;

  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(borderRadiusValueSmall));
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(borderRadiusValue));

  static const EdgeInsets edge4 = EdgeInsets.all(4.0);
  static const EdgeInsets edge8 = EdgeInsets.all(8.0);

  static const SizedBox padding4 = SizedBox(height: 4, width: 4,);
  static const SizedBox padding8 = SizedBox(height: 8, width: 8,);

  static const double _buttonTargetHeight = 52;

  static const EdgeInsets buttonPadding     = EdgeInsets.symmetric(vertical: 10, horizontal: 20);
  static const EdgeInsets textFieldPadding  = EdgeInsets.symmetric(vertical: 18, horizontal: 20);
  // textFieldPadding.vertical = (_buttonTargetHeight - body1.fontHeight:20) / 2);

  static const double buttonContentHeight = 32; //_buttonTargetHeight - buttonPadding.vertical * 2;

  static const EdgeInsets toastPadding = EdgeInsets.fromLTRB(16, 10, 16, 10);
  static const double toastHeight = 44.0;
}