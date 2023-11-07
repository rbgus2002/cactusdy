
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/widgets/diagrams/squircle.dart';

class SquircleButton extends StatelessWidget {
  final Widget? child;
  final double scale;
  final BorderSide? side;

  const SquircleButton({
    Key? key,
    this.child,
    required this.scale,
    this.side,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final additionalColor = Theme.of(context).extension<AdditionalColor>()!;

    return SizedBox(
      width: scale,
      height: scale,
      child: ClipPath.shape(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: const SquircleBorder(),
        child: Material(
          color: additionalColor.inputFieldBackgroundColor,
          shape: SquircleBorder(
            side: side??BorderSide(color: additionalColor.grey200!, width: 2)),
          child: child,)
      ),
    );
  }
}