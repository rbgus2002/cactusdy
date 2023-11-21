import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_study_app/routes/backdoor_route.dart';
import 'package:group_study_app/routes/start_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/logo.dart';

class SplashRoute extends StatefulWidget {
  const SplashRoute({
    Key? key,
  }) : super(key: key);

  @override
  State<SplashRoute> createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
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