import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';

class OldPanel extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  final double marginBottom;

  const OldPanel({
    Key? key,
    required this.onTap,
    required this.child,
    this.marginBottom = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      child: Ink(
          decoration: const BoxDecoration(
            borderRadius: Design.borderRadiusBig,
          ),
          child: InkWell(
            borderRadius: Design.borderRadiusBig,
            onTap: onTap,
            child: Container(
              child: child,
            ),
            onLongPress: null,
          )
      ),
    );
  }
}