

import 'package:flutter/material.dart';
import 'package:groupstudy/models/status_tag.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/widgets/tags/rounded_tag.dart';

class StatusTagWidget extends RoundedTag {
  StatusTagWidget({
    Key? key,
    required BuildContext context,
    required StatusTag status,
    required bool reserved,
    required super.onTap,
    super.width = 60,
    super.height = 36,
  }) : super(
    key: key,
    text: Text(
      status.text(context, reserved),
      style: (width >= 60)?
        TextStyles.head5.copyWith(color: context.extraColors.grey600) :
        TextStyles.caption1.copyWith(color: context.extraColors.grey700)),
    color: status.color(context),
  );
}