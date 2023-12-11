import 'dart:async';

import 'package:flutter/material.dart';
import 'package:group_study_app/routes/home_route.dart';
import 'package:group_study_app/routes/start_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:lottie/lottie.dart';

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
      if (Auth.signInfo == null) {
        Util.replaceRouteWithFade(context, (context, animation, secondaryAnimation) => const StartRoute());
      }
      else {
        debugPrint(Auth.signInfo!.token); //< FIXME
        Util.replaceRouteWithFade(context, (context, animation, secondaryAnimation) => const HomeRoute());
        //Util.pushRoute(context, (context) => DateTimePickerRoute());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          Design.splashLottiePath,
          width: 134,),
      ),
    );
  }
}