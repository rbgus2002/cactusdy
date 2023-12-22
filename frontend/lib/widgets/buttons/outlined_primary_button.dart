
import 'package:flutter/material.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';

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