import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/home_route.dart';
import 'package:group_study_app/routes/round_detail_route.dart';
import 'package:group_study_app/routes/start_route.dart';
import 'package:group_study_app/routes/studies/study_detail_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/services/message_service.dart';
import 'package:group_study_app/services/notification_channel.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:lottie/lottie.dart';

/// in Splash Route, these works will happened.
/// 1. Show splash image.
/// 2. Check Auth Info (sign in or not).
/// 3. Handle Notification(Message) Touch Event.
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
        MessageService.setupInteractedMessage(_handleMessage);
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

  void _handleMessage(RemoteMessage message) {
    switch (message.data['type']) {
      case 'study':
        int studyId = int.parse(message.data['studyId']);

        _viewStudy(studyId);
        break;

      case 'round':
        int studyId = int.parse(message.data['studyId']);
        int roundId = int.parse(message.data['roundId']);
        int roundSeq = int.parse(message.data['roundSeq']);

        _viewRound(studyId, roundId, roundSeq);
        break;

      // [Fallthrough] : not implemented yet
      case 'notice':
      case 'others':
      default:
        // TODO: implement later
        break;
    }
  }

  Future<Study?> _viewStudy(int studyId) async {
    try {
      Study study = await Study.getStudySummary(studyId);

      // TODO: have to implement foreground handler
      if (context.mounted) {
        Util.pushRoute(context, (context) =>
            StudyDetailRoute(study: study));
      }

      return study;
    } on Exception catch (e) {
      if (context.mounted) {
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }

  void _viewRound(int studyId, int roundId, int roundSeq) async {
    _viewStudy(studyId).then((study) {
      if (study != null) {
        RoundDetailRoute(
          roundSeq: roundSeq,
          roundId: roundId,
          study: study,
        );
      }
    });
  }
}