
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';

class Toast {
  static const duration = Duration(seconds: 2);

  static void showToast( {
    required BuildContext context,
    required String message,
    EdgeInsets? margin,
  }) {
    FToast fToast = FToast();
    fToast.init(context);

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

    fToast.showToast(
        child: toast,
        toastDuration: duration,
        gravity: ToastGravity.BOTTOM,
    );
  }
}