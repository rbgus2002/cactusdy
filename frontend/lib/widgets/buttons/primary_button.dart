import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extra_color_extension.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double width;
  final bool enabled;

  const PrimaryButton({
    Key? key,
    this.onPressed,
    this.width = double.infinity,
    required this.text,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: context.extraColors.disabledPrimaryButtonColor,
          disabledForegroundColor: context.extraColors.grey000),
        child: Container(
          width: width,
          height: Design.buttonContentHeight,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyles.head4,
          ),
        ),
      );
  }
}