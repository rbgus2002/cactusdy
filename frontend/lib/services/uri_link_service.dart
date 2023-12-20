

import 'package:group_study_app/routes/studies/study_participating_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/services/logger.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:uni_links/uni_links.dart';

class UriLinkService {
  UriLinkService._();

  static Logger logger = Logger('UriLinker');

  static void init() {
    uriLinkStream.listen(
      (Uri? uri) {
        if (uri != null) {
          logger.log(uri.toString());
          _invitingCodeHandler(uri);
        }
      },
      onError: (e) {
        logger.log(e.toString());
      }
    );
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