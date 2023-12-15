import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:group_study_app/routes/splash_route.dart';
import 'package:group_study_app/services/kakao_service.dart';
import 'package:group_study_app/services/message_service.dart';
import 'package:group_study_app/themes/app_theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MessageService.initMessageService();
  KakaoService.init();
  AppTheme.initTheme();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: AppTheme.themeMode,
        builder: (context, themeMode, child) => MaterialApp(
          home: const SplashRoute(),

          themeMode: themeMode,
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
          ],)
    );
  }
}