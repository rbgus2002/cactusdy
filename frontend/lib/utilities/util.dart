
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:group_study_app/themes/old_color_styles.dart';

class Util {
  static const int _exceptionTextLength = "Exception: ".length;
  static const Duration textEditingWaitingTime = Duration(milliseconds: 12);

  static Function doNothing() {
    return () {};
  }

  static Future<void> pushRoute(BuildContext context, WidgetBuilder builder) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: builder),
    );
  }

  static Future<void> pushRouteAndPopUntil(BuildContext context, WidgetBuilder builder) async {
    await Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: builder),
        (route) => false
    );
  }

  static void popRoute(BuildContext context) {
    Navigator.of(context).pop();
  }

  static SlideTransition _slideDown(BuildContext context, Animation<double> animation,  Animation<double> secondaryAnimation, Widget child) {
    Offset top = const Offset(0.0, -1.0);
    Offset center = Offset.zero;

    var tween = Tween(begin: top, end: center).chain(CurveTween(curve: Curves.ease));

    return SlideTransition(
        position: animation.drive(tween),
        child: child,
    );
  }

  static pushRouteWithSlideDown(BuildContext context, RoutePageBuilder builder) async {
    return await Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: builder,
          transitionsBuilder: _slideDown,)
    );
  }

  static Color progressToColor(double taskProgress) {
    Color color = (taskProgress > 0.8)? OldColorStyles.green :
    (taskProgress > 0.5)? OldColorStyles.orange : OldColorStyles.red;

    return color;
  }

  static void delay(VoidCallback function) async {
    Future.delayed(const Duration(milliseconds: 300), function);
  }

  static String getExceptionMessage(Exception e) {
    return e.toString().substring(_exceptionTextLength);
  }
}