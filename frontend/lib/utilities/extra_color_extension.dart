
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';

extension ExtraColorsExtension on BuildContext {
  ExtraColors get extraColors => Theme.of(this).extension<ExtraColors>()!;
}
