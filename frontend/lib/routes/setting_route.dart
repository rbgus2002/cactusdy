

import 'package:flutter/material.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/routes/feedback_route.dart';
import 'package:groupstudy/routes/start_route.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/themes/app_theme.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/dialogs/two_button_dialog.dart';

class _ThemeModeData {
  ThemeMode mode;
  String text;

  _ThemeModeData(this.mode, this.text);
}

class SettingRoute extends StatefulWidget {
  final User user;

  const SettingRoute({
    super.key,
    required this.user,
  });

  @override
  State<SettingRoute> createState() => _SettingRouteState();
}

class _SettingRouteState extends State<SettingRoute> {
  static const double _entityHeight = 40;

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
        leading: const SlowBackButton(),
        title: Text(context.local.setting),),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Design.padding32,

          // Theme Setting
          _themeSettingWidget(),

          // ETC Setting
          _etcSettingWidget(),
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
        Design.padding16,

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

  /// etc = { signOut, resign, }
  Widget _etcSettingWidget() {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(
          color: context.extraColors.grey200!,),),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Design.padding28,

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              '${context.local.etc} ${context.local.setting}',
              style: TextStyles.head4.copyWith(
                color: context.extraColors.grey800,),),),
          Design.padding16,

          // Feedback Button
          _feedbackButton(),

          // Logout Button
          _signOutButton(),

          // Resign button
          _resignButton(),
          Design.padding20,
        ],
      ),
    );
  }

  Widget _feedbackButton() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
          const FeedbackRoute()),
      child: Container(
        width: double.maxFinite,
        height: _entityHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          context.local.feedback,
          style: TextStyles.body1.copyWith(
            color: context.extraColors.grey700,),),),
    );
  }

  Widget _signOutButton() {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: _showSignOutDialog,
      child: Container(
        width: double.maxFinite,
        height: _entityHeight,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          context.local.signOut,
          style: TextStyles.body1.copyWith(
            color: context.extraColors.grey700,),),),
    );
  }

  Widget _resignButton() {
    return Container(
      width: 108,
      height: _entityHeight,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: _showResignDialog,
        child: Text(
          context.local.resign,
          style: TextStyles.body1.copyWith(
            color: context.extraColors.grey500,),),),
    );
  }

  Widget _checkBox(BuildContext context, int index) {
    return InkWell(
      onTap: () => _setMode(index),
      child: Container(
        height: _entityHeight,
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
    TwoButtonDialog.showDialog(
      context: context,
      text: context.local.ensureToDo(context.local.signOut),

      buttonText1: context.local.no,
      onPressed1: Util.doNothing,

      buttonText2: context.local.signOut,
      onPressed2: _signOut,
    );
  }

  void _showResignDialog() {
    TwoButtonDialog.showDialog(
      context: context,
      text: context.local.ensureToResign,
      maxLines: 5,

      buttonText1: context.local.no,
      onPressed1: Util.doNothing,

      buttonText2: context.local.delete,
      onPressed2: _showResignWarningDialog,
    );
  }

  void _showResignWarningDialog() {
    TwoButtonDialog.showDialog(
      context: context,
      text: context.local.resignWarning,
      maxLines: 2,

      buttonText1: context.local.cancel,
      onPressed1: Util.doNothing,

      buttonText2: context.local.resign,
      onPressed2: _resignFromApp,
    );
  }

  void _signOut() async {
    try {
      await Auth.removeFCMToken();
      await Auth.signOut();

      if (mounted) {
        Util.pushRouteAndPopUntil(context, (context)
            => const StartRoute());
      }
    } on Exception catch(e) {
      if (mounted) {
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }

  void _resignFromApp() {
    try {
      User.resign(widget.user).then((result) {
        if (result == true) {
          Auth.signOut();
          Util.pushRouteAndPopUntil(context, (context) => const StartRoute());
        }
      });
    } on Exception catch(e) {
      Toast.showToast(
          context: context,
          message: Util.getExceptionMessage(e));
    }
  }
}
