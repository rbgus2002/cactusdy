

import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:groupstudy/routes/studies/study_participating_route.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:groupstudy/utilities/util.dart';

class AppLinkService {
  AppLinkService._();

  static Logger logger = Logger('AppLinker');
  static late StreamSubscription _linkSubscription;

  static void init() {
    _handleIncomingUri();

    // handleInitialUri will called in [splash_route.dart] After playing Lottie,
    // not here.
    //handleInitialUri();
  }

  static Future<void> handleInitialUri() async {
    AppLinks().getInitialLink().then((uri) {
      try {
        if (uri != null) {
          logger.infoLog(uri.toString());
          _invitingCodeHandler(uri);
        }
      } on Exception catch (e) {
        logger.infoLog(e.toString());
      }
    });
  }

  static Future<void> _handleIncomingUri() async {
    _linkSubscription = AppLinks().uriLinkStream.listen((Uri? uri) {
      if (uri != null) {
        logger.infoLog(uri.toString());
        _invitingCodeHandler(uri);
      }
    }, onError: (e) {
      logger.infoLog(e.toString());
    });
  }

  static void _invitingCodeHandler(Uri uri) {
    if (uri.queryParameters.containsKey('invitingCode')) {
      if (Auth.signInfo != null) {
        String invitingCode = uri.queryParameters['invitingCode']??"";
        Util.pushRouteByKey((context) =>
            StudyParticipantRoute(invitingCode: invitingCode,));
      }
    }
  }
}
