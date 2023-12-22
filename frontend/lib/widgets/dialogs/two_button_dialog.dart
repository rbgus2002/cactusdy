import 'dart:async';

import 'package:flutter/material.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/outlined_primary_button.dart';
import 'package:groupstudy/widgets/buttons/primary_button.dart';

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
    //bool isOutlined1 = false,
    required String buttonText2,
    required VoidCallback onPressed2,
    //bool isOutlined2 = true,
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
                      style: TextStyles.head3.copyWith(
                          color: context.extraColors.grey800),),),
                  Design.padding32,

                  PrimaryButton(
                      text: buttonText1,
                      onPressed: () {
                        Util.popRoute(context);
                        onPressed1(); }),
                  Design.padding12,

                  OutlinedPrimaryButton(
                    text: buttonText2,
                    onPressed: () {
                      Util.popRoute(context);
                      onPressed2(); })
                ],),),
          );
        }
    );
  }
}