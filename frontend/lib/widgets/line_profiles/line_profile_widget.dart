import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';

class LineProfileWidget extends StatelessWidget {
  final CircleButton circleButton;
  final Widget topWidget;
  final Widget bottomWidget;
  final IconButton? iconButton;

  const LineProfileWidget({
    super.key,
    required this.circleButton,
    required this.topWidget,
    required this.bottomWidget,
    this.iconButton,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        circleButton,

        Design.padding5,
        Flexible(
          fit: FlexFit.tight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              Design.padding5,
              topWidget,
              bottomWidget,
            ],
          ),
        ),

        if(iconButton != null)
          iconButton!,
      ],
    );
  }
}