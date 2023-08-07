import 'package:flutter/material.dart';

class Util {
  static void pushRoute(BuildContext context, WidgetBuilder builder) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: builder),
    );
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