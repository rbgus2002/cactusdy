import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/outlined_primary_button.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';

class TwoButtonDialog {
  TwoButtonDialog._();

  static const double _innerWidth = 260;
  static const double _textWidth = 232;
  static const EdgeInsets _padding = EdgeInsets.all(16);

  static Future<dynamic> showProfileDialog({
    required BuildContext context,
    required String text,
    int maxLines = 1,
    required String buttonText1,
    required VoidCallback onPressed1,
    bool isOutlined1 = false,
    required String buttonText2,
    required VoidCallback onPressed2,
    bool isOutlined2 = true,
  }) {
    return showDialog(
        barrierColor: context.extraColors.barrierColor!,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: Design.borderRadiusBig,),
            insetPadding: _padding,
            backgroundColor: context.extraColors.grey50,
            content: SizedBox(
              width: _innerWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Design.padding12,

                  Container(
                    constraints: const BoxConstraints(maxWidth: _textWidth),
                    child: Text(
                      text,
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyles.head4.copyWith(
                          color: context.extraColors.grey800),),),
                  Design.padding32,

                  (isOutlined1)?
                    OutlinedPrimaryButton(
                      text: buttonText1,
                      onPressed: () {
                        Util.popRoute(context);
                        onPressed1(); }) :
                    PrimaryButton(
                        text: buttonText1,
                        onPressed: () {
                          Util.popRoute(context);
                          onPressed1(); }),
                  Design.padding12,

                  (isOutlined2)?
                    OutlinedPrimaryButton(
                      text: buttonText2,
                      onPressed: () {
                        Util.popRoute(context);
                        onPressed2(); }) :
                    PrimaryButton(
                      text: buttonText2,
                      onPressed: () {
                        Util.popRoute(context);
                        onPressed2(); }),
                ],),),
          );
        }
    );
  }
}