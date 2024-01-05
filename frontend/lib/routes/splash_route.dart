import 'dart:async';

import 'package:flutter/material.dart';
import 'package:groupstudy/routes/home_route.dart';
import 'package:groupstudy/routes/start_route.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/services/uri_link_service.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:lottie/lottie.dart';

/// in Splash Route, these works will happened.
/// 1. Show splash image.
/// 2. Check Auth Info (sign in or not).
class SplashRoute extends StatefulWidget {
  const SplashRoute({ super.key, });

  @override
  State<SplashRoute> createState() => _SplashRouteState();
}

class _SplashRouteState extends State<SplashRoute> {
  static const _splashDuration = Duration(seconds: 1);

  @override
  void initState() {
    super.initState();

    Auth.loadSignInfo();

    Timer(_splashDuration, () {
      if (Auth.signInfo == null) {
        Util.replaceRouteWithFade(context, (context, animation, secondaryAnimation) => const StartRoute());
      }
      else {
        Util.replaceRouteWithFade(context, (context, animation, secondaryAnimation) => const HomeRoute());
        UriLinkService.handleInitialUri();
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