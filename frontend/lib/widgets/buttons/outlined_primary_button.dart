
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';

class OutlinedPrimaryButton extends PrimaryButton {
  const OutlinedPrimaryButton({
    super.key,
    super.onPressed,
    super.width,
    required super.text,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        onPressed: onPressed,
        child: Container(
          width: width??double.maxFinite,
          height: Design.buttonContentHeight,
          alignment: Alignment.center,
          child: Text(
            text,
            style: TextStyles.head4,),),
    );
  }
}