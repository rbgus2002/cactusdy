import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extra_color_extension.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';

class SecondaryButton extends PrimaryButton {
  const SecondaryButton({
    super.key,
    super.onPressed,
    super.width,
    required super.text,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: context.extraColors.secondButtonColor,
          disabledBackgroundColor: context.extraColors.grey300,
          disabledForegroundColor: context.extraColors.grey000,
      ),
      onPressed: onPressed,
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