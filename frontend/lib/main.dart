import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_study_app/routes/backdoor_route.dart';
import 'package:group_study_app/routes/start_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/new_text_styles.dart';
import 'package:group_study_app/services/notification_service.dart';
import 'package:group_study_app/utilities/util.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MessageService.initMessageService();

  runApp(MaterialApp(
    title: 'asd', //< FIXME
    home: const MyApp(),
    theme: ThemeData(
      fontFamily: NewTextStyles.mainFont,

      primaryColor: Colors.black87,
      buttonTheme: const ButtonThemeData(buttonColor: Colors.black87),
      appBarTheme: const AppBarTheme(color: Colors.black87),
      elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(backgroundColor: Colors.black87)),
      focusColor: Colors.transparent,
    ),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

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
    return Center(
      //< FIXME : Add Splash
      child: Text("SPLASH~"),
    );
  }
}