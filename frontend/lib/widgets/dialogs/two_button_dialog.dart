import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/outlined_primary_button.dart';
import 'package:group_study_app/widgets/buttons/secondary_button.dart';

class TwoButtonDialog {
  static const double _innerWidth = 260;
  static const double _textWidth = 232;
  static const EdgeInsets _padding = EdgeInsets.all(16);

  static Future<dynamic> showProfileDialog({
    required BuildContext context,
    required String text,
    required String buttonText1,
    required VoidCallback onPressed1,
    required String buttonText2,
    required VoidCallback onPressed2,
  }) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: Design.borderRadiusBig,),
            insetPadding: _padding,
            content: SizedBox(
              width: _innerWidth,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Design.padding12,

                  SizedBox(
                    width: _textWidth,
                    child: Text(
                      text,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.head3.copyWith(
                          color: context.extraColors.grey900)),),
                  Design.padding32,

                  OutlinedPrimaryButton(
                    text: buttonText1,
                    onPressed: () {
                      Util.popRoute(context);
                      onPressed1();
                    }),
                  Design.padding12,

                  SecondaryButton(
                    text: buttonText2,
                    onPressed: () {
                      Util.popRoute(context);
                      onPressed2();
                    }),
                ],),),
          );
        }
    );
  }
}