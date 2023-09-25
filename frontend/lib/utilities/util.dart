import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';

class Util {
  static void pushRoute(BuildContext context, WidgetBuilder builder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: builder),
    );
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
}