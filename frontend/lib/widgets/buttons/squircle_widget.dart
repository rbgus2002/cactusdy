
import 'package:flutter/material.dart';
import 'package:group_study_app/utilities/extra_color_extension.dart';
import 'package:group_study_app/widgets/diagrams/squircle.dart';

class SquircleWidget extends StatelessWidget {
  final Widget? child;
  final double scale;
  final BorderSide? side;

  const SquircleWidget({
    Key? key,
    this.child,
    required this.scale,
    this.side,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: scale,
      height: scale,
      child: ClipPath.shape(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const SquircleBorder(),
        child: Material(
          color: context.extraColors.inputFieldBackgroundColor,
          shape: SquircleBorder(
            side: side??BorderSide(color: context.extraColors.grey200!, width: 2)),
          child: child,)
      ),
    );
  }
}