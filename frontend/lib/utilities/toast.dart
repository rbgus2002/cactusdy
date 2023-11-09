
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extra_color_extension.dart';


class Toast {
  static const duration = Duration(seconds: 2);

  static void showToast( {
    required BuildContext context,
    required String message
  }) {
    FToast fToast = FToast();
    fToast.init(context);

    Widget toast = Container(
      height: Design.toastHeight,
      width: Design.targetWidth,
      padding: Design.toastPadding,
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