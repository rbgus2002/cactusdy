
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';

class Toast {
  Toast._();

  static const durationSeconds = 2;
  static const duration = Duration(seconds: durationSeconds);

  // For prevent duplication
  static String lastMessage = "";
  static DateTime lastTime = DateTime.now();

  static final FToast _fToast = FToast();

  static void showToast( {
    required BuildContext context,
    required String message,
    EdgeInsets? margin,
  }) {
    if (_isSameMessage(message) && _isPlaying()) return;
    
    _setPlaying(message);

    _fToast.removeCustomToast();
    _fToast.init(context);

    Widget toast = Container(
      height: Design.toastHeight,
      width: Design.targetWidth,
      padding: Design.toastPadding,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: Design.borderRadius,
        color: context.extraColors.grey900),
      alignment: Alignment.centerLeft,
      child: Text(
          message,
          style: TextStyles.body1.copyWith(
              color: context.extraColors.grey200),
      ),
    );

    _fToast.showToast(
        child: toast,
        toastDuration: duration,
        gravity: ToastGravity.BOTTOM,
        isDismissable: true,
    );
  }

  static bool _isPlaying() {
    return (DateTime.now().difference(lastTime).inSeconds < durationSeconds);
  }

  static bool _isSameMessage(String message) {
    return (lastMessage == message);
  }

  static void _setPlaying(String message) {
    lastMessage = message;
    lastTime = DateTime.now();
  }
}