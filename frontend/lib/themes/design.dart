import 'package:flutter/material.dart';

class Design {
  static const String defaultImagePath = 'assets/images/default_profile.png';

  static const double targetWidth = 512;

  static const double borderRadiusValueSmall = 4.0;
  static const double borderRadiusValue = 8.0;
  static const double borderRadiusValueBig = 12.0;

  static const BorderRadius borderRadiusSmall = BorderRadius.all(Radius.circular(borderRadiusValueSmall));
  static const BorderRadius borderRadius = BorderRadius.all(Radius.circular(borderRadiusValue));
  static const BorderRadius borderRadiusBig = BorderRadius.all(Radius.circular(borderRadiusValueBig));

  static const EdgeInsets edge4 = EdgeInsets.all(4.0);
  static const EdgeInsets edge8 = EdgeInsets.all(8.0);
  static const EdgeInsets edge16 = EdgeInsets.all(16.0);
  static const EdgeInsets edge20 = EdgeInsets.all(20.0);
  static const EdgeInsets edgePadding = edge20;

  // real size = padding / 4
  static const SizedBox padding4 = SizedBox(height: 4, width: 4, );
  static const SizedBox padding8 = SizedBox(height: 8, width: 8,);
  static const SizedBox padding12 = SizedBox(height: 12, width: 12,);
  static const SizedBox padding16 = SizedBox(height: 16, width: 16,);
  static const SizedBox padding20 = SizedBox(height: 20, width: 20,);
  static const SizedBox padding28 = SizedBox(height: 28, width: 28,);
  static const SizedBox padding32 = SizedBox(height: 28, width: 28,);
  static const SizedBox padding48 = SizedBox(height: 48, width: 48,);

  static SizedBox padding(double size) {
    return SizedBox(height: size, width: size);
  }

  static const double _buttonTargetHeight = 52;

  static const EdgeInsets buttonPadding     = EdgeInsets.symmetric(vertical: 10, horizontal: 20);
  static const EdgeInsets textFieldPadding  = EdgeInsets.symmetric(vertical: 16, horizontal: 20);
  // textFieldPadding.vertical = (_buttonTargetHeight - body1.fontHeight:20) / 2);

  static const double buttonContentHeight = 32; //_buttonTargetHeight - buttonPadding.vertical * 2;

  static const EdgeInsets toastPadding = EdgeInsets.fromLTRB(16, 10, 16, 10);
  static const double toastHeight = 44.0;

  static final List<BoxShadow> basicShadows = [ BoxShadow(
    color: Colors.black.withOpacity(0.25),
    blurRadius: 4,
    offset: const Offset(0, 4),
  )];


  static const Widget loadingIndicator = SizedBox(
      height: 128,
      child: Center(
          child: CircularProgressIndicator()
      )
  );
}