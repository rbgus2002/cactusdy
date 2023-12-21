
import 'package:flutter/material.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';

class KakaoStyleButton extends StatelessWidget {
  static const _containerColor = Color(0xFFFEE500);
  static const _symbolColor = Color(0xFF000000);
  static const _labelColor = Color(0xD9000000);

  final VoidCallback? onPressed;
  final String text;
  final double? width;
  final bool enabled;

  const KakaoStyleButton({
    Key? key,
    this.onPressed,
    this.width,
    required this.text,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _containerColor,),
      onPressed: onPressed,
      child: Container(
        width: width??double.maxFinite,
        height: Design.buttonContentHeight,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/kakao_symbol.png',
              height: TextStyles.head4.fontSize,
              color: _symbolColor,),
            Design.padding8,

            Text(
              text,
              style: TextStyles.head4.copyWith(color: _labelColor),),
          ],
        ),),
    );
  }
}