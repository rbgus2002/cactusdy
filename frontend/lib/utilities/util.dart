
import 'package:flutter/material.dart';
import 'package:group_study_app/models/sign_info.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:device_info_plus/device_info_plus.dart';

class Util {
  static const int _exceptionTextLength = "Exception: ".length;
  static const Duration textEditingWaitingTime = Duration(milliseconds: 12);

  static void pushRoute(BuildContext context, WidgetBuilder builder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: builder),
    );
  }

  static void pushRouteAndPopUtil(BuildContext context, WidgetBuilder builder) {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: builder),
        (route) => false
    );
  }

  static void popRoute(BuildContext context) {
    Navigator.of(context).pop();
  }

  static Color progressToColor(double taskProgress) {
    Color color = (taskProgress > 0.8)? ColorStyles.green :
    (taskProgress > 0.5)? ColorStyles.orange : ColorStyles.red;

    return color;
  }

  @deprecated
  static Widget customIconButton({
    required Icon icon,
    Function? onTap,
  }) {
    return IconButton(
      icon: icon,
      splashRadius: 16,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () {
        if (onTap != null) { onTap!(); }
      }
    );
  }

  static String getExceptionMessage(Exception e) {
    return e.toString().substring(_exceptionTextLength);
  }
}