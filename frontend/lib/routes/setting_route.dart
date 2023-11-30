

import 'package:flutter/material.dart';
import 'package:group_study_app/routes/start_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/app_theme.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/dialogs/two_button_dialog.dart';

class _ThemeModeData {
  ThemeMode mode;
  String text;

  _ThemeModeData(this.mode, this.text);
}

class SettingRoute extends StatefulWidget {
  const SettingRoute({
    Key? key
  }) : super(key: key);

  @override
  State<SettingRoute> createState() => _SettingRouteState();
}

class _SettingRouteState extends State<SettingRoute> {
  late int _choseIdx;
  List<_ThemeModeData> _modes = [];

  @override
  void initState() {
    super.initState();
    _choseIdx = _getInitModeIndex();
  }

  @override
  Widget build(BuildContext context) {
    // it use context, so it is impossible to init in initState
    _modes = [
      _ThemeModeData(ThemeMode.light, context.local.lightMode),
      _ThemeModeData(ThemeMode.dark, context.local.darkMode),
      _ThemeModeData(ThemeMode.system, context.local.systemMode),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(context.local.setting),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Design.padding32,

          // Theme Setting
          _themeSettingWidget(),

          // Logout Button
          _signOutButton(),
        ],),
    );
  }

  Widget _themeSettingWidget() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            context.local.themeMode,
            style: TextStyles.head4.copyWith(
                color: context.extraColors.grey800),),),
        Design.padding20,

        // Light Mode
        _checkBox(context, 0),
        // Dark Mode
        _checkBox(context, 1),
        // System Mode
        _checkBox(context, 2),

        Design.padding20,
      ],
    );
  }

  Widget _signOutButton() {
    return Container(
      padding: Design.edgePadding,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: context.extraColors.grey200!,),),),
      child: InkWell(
        splashColor: Colors.transparent,
          onTap: _showSignOutDialog,
          child: Container(
            width: double.maxFinite,
            height: 40,
            alignment: Alignment.centerLeft,
            child: Text(
              context.local.signOut,
              style: TextStyles.head4.copyWith(
                color: context.extraColors.grey800,),),),
      ),
    );
  }

  Widget _checkBox(BuildContext context, int index) {
    return InkWell(
      onTap: () => _setMode(index),
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                _modes[index].text,
                style: TextStyles.body1.copyWith(
                  color: context.extraColors.grey700,),),),

            Visibility(
              visible: index == _choseIdx,
              child: const Icon(
                CustomIcons.check1,
                color: ColorStyles.mainColor,
                size: 32,),),
          ],
        ),
      ),
    );
  }

  int _getInitModeIndex() {
    switch (AppTheme.themeMode.value) {
      case ThemeMode.light:
        return 0;
      case ThemeMode.dark:
        return 1;
      case ThemeMode.system:
        return 2;
    }
  }

  void _setMode(int index) {
    assert(index >= 0 && index < 3, 'out of range : 0..2 but index = $index');
    setState(() => _choseIdx = index);
    AppTheme.setTheme(_modes[index].mode);
  }

  void _showSignOutDialog() {
    TwoButtonDialog.showProfileDialog(
      context: context,
      text: context.local.ensureToDo(context.local.signOut),

      buttonText1: context.local.signOut,
      onPressed1: _signOut,

      buttonText2: context.local.close,
      onPressed2: () {}, // Assert to do nothing
    );
  }

  void _signOut() {
    Auth.signOut();
    Util.pushRouteAndPopUntil(context, (context) => const StartRoute());
  }
}
