

import 'package:flutter/foundation.dart';
import 'package:groupstudy/routes/studies/study_participating_route.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:uni_links/uni_links.dart';

class UriLinkService {
  UriLinkService._();

  static Logger logger = Logger('UriLinker');
  static bool _isHandled = false;

  static void init() {
    _handleIncomingUri();

    // handleInitialUri will called in [splash_route.dart] After playing Lottie,
    // not here.
    //handleInitialUri();
  }

  /// for Handle initial links at start
  /// it is need to be called only once
  static Future<void> handleInitialUri() async {
    if (!_isHandled) {
      _isHandled = true;

      try {
        final uri = await getInitialUri();
        if (uri != null) {
          logger.log(uri.toString());
          _invitingCodeHandler(uri);
        }
      } on Exception catch(e) {
        logger.log(e.toString());
      }
    }
  }

  /// for Handle incoming links after start
  static void _handleIncomingUri() {
    if (!kIsWeb) {
      uriLinkStream.listen(
        (Uri? uri) {
          if (uri != null) {
            logger.log(uri.toString());
            _invitingCodeHandler(uri);
          }},
        onError: (e) {
          logger.log(e.toString());
        });
    }
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