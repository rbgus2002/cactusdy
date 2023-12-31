import 'dart:async';
import 'dart:ui';

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

  static Future<dynamic> showDialog({
    required BuildContext context,
    required String text,
    int maxLines = 1,
    required String buttonText1,
    required VoidCallback onPressed1,
    required String buttonText2,
    required VoidCallback onPressed2,
  }) {
    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: context.extraColors.barrierColor!.withOpacity(0.2),
        pageBuilder: (context, animation, secondaryAnimation) {
          return BackdropFilter(
            filter: Design.basicBlur,
            child: AlertDialog(
              shape: const RoundedRectangleBorder(
                borderRadius: Design.borderRadiusBig,),
              insetPadding: _padding,
              backgroundColor: context.extraColors.grey50!.withOpacity(0.95),
              shadowColor: Colors.transparent,
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
            ),
          );
        }
    );
  }
}