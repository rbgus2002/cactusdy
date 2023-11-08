import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:group_study_app/routes/backdoor_route.dart';
import 'package:group_study_app/routes/start_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/services/notification_service.dart';
import 'package:group_study_app/themes/app_theme.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/logo.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MessageService.initMessageService();

  runApp(MaterialApp(
    home: const MyApp(),
    theme: AppTheme.themeData,
    darkTheme: AppTheme.darkThemeData,

    localizationsDelegates: const [
      AppLocalizations.delegate,
      GlobalMaterialLocalizations.delegate,
      GlobalWidgetsLocalizations.delegate,
      GlobalCupertinoLocalizations.delegate,
    ],
    supportedLocales: const [
      Locale('ko', ''),
    ],
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({
    Key? key
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const _splashDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();

    Auth.getSignInfo();

    Timer(_splashDuration, () {
      Navigator.of(context).pop();
      if (Auth.signInfo == null) {
        Util.pushRoute(context, (context) => const StartRoute());
      }
      else {
        Util.pushRoute(context, (context) => const BackdoorRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: Logo(),
      ),
    );
  }
}