

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:group_study_app/routes/splash_route.dart';
import 'package:group_study_app/services/kakao_service.dart';
import 'package:group_study_app/services/message_service.dart';
import 'package:group_study_app/services/uri_link_service.dart';
import 'package:group_study_app/themes/app_theme.dart';
import 'package:group_study_app/utilities/extensions.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  LocalizationExtension.init();
  MessageService.init();
  KakaoService.init();
  UriLinkService.init();
  AppTheme.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  static final GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  const MyApp({
    Key? key
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: AppTheme.themeMode,
      builder: (context, themeMode, child) =>
        MaterialApp(
          home: const SplashRoute(),
          navigatorKey: navigationKey,

          themeMode: themeMode,
          theme: AppTheme.themeData,
          darkTheme: AppTheme.darkThemeData,

          locale: const Locale('ko'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
    );
  }
}