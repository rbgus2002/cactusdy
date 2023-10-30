import 'package:flutter/material.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';

class LineProfileWidget extends StatelessWidget {
  final Widget circleButton;
  final Widget topWidget;
  final Widget bottomWidget;
  final Widget? suffixWidget;

  const LineProfileWidget({
    super.key,
    required this.circleButton,
    required this.topWidget,
    required this.bottomWidget,
    this.suffixWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      //crossAxisAlignment: CrossAxisAlignment.start,

      children: [
        circleButton,

        OldDesign.padding5,
        Flexible(
          fit: FlexFit.tight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              topWidget,
              bottomWidget,
            ],
          ),
        ),

        if(suffixWidget != null)
          suffixWidget!,
      ],
    );
  }
}