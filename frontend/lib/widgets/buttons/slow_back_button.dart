

import 'package:flutter/material.dart';

class SlowBackButton extends StatelessWidget {
  static const _duration = Duration(milliseconds: 500);
  static DateTime _lastPressed = DateTime(0);

  final Icon? icon;
  final Color? color;
  final ButtonStyle? style;
  final bool isClose;

  const SlowBackButton({
    super.key,
    this.icon,
    this.color,
    this.style,
    this.isClose = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: IconButton(
        icon: (isClose)?
          const CloseButtonIcon() :
          const BackButtonIcon(),
        style: style,
        color: color,
        splashRadius: 20,
        onPressed: () => _slowBack(context),
      ),
    );
  }

  void _slowBack(BuildContext context) {
    DateTime now = DateTime.now();

    if (now.difference(_lastPressed) >= _duration) {
      _lastPressed = now;
      Navigator.maybePop(context);
    }
  }
}