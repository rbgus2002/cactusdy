import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/extra_color_extension.dart';

class Panel extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  final double marginBottom;

  const Panel({
    Key? key,
    required this.onTap,
    required this.child,
    this.marginBottom = 15,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: marginBottom),
      child: Ink(
          decoration: BoxDecoration(
            borderRadius: Design.borderRadiusBig,
            color: context.extraColors.grey000,
          ),
          child: InkWell(
            borderRadius: Design.borderRadiusBig,
            onTap: onTap,
            child: Container(
              padding: Design.edgePadding,
              child: child,
            ),
          )
      ),
    );
  }
}