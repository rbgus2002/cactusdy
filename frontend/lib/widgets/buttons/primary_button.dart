import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final double? width;
  final bool enabled;

  const PrimaryButton({
    Key? key,
    this.onPressed,
    this.width,
    required this.text,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
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