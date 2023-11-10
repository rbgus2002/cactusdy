
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:group_study_app/themes/color_styles.dart';

extension ExtraColorsExtension on BuildContext {
  ExtraColors get extraColors => Theme.of(this).extension<ExtraColors>()!;
}

extension LocalizationExtension on BuildContext {
  AppLocalizations get local => AppLocalizations.of(this)!;
}