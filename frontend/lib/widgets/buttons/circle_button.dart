import 'package:flutter/material.dart';


class CircleButton extends StatelessWidget {
  static const String defaultImagePath = 'assets/images/default_profile.png';

  final double scale;
  final Widget? child;
  final Function? onTap;

  const CircleButton({
    Key? key,
    this.scale = 20.0,
    this.child,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: SizedBox(
        width: scale,
        height: scale,

        child: Material(
          child: InkWell(
            child: child ?? Image.asset(defaultImagePath),
            onTap: () {
              if (onTap != null) {
                onTap!();
              }
            },
        )),
      ));
  }
}