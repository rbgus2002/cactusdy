

import 'package:flutter/material.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:kakao_flutter_sdk_share/kakao_flutter_sdk_share.dart';

class KakaoService {
  KakaoService._();

  static final Logger logger = Logger('KakaoSharing');

  static void init() {
    KakaoSdk.init(
      nativeAppKey: '5d97b9a890c6846794e0bebdf1f6cfa7',
      javaScriptAppKey: 'c842ffecfc1fbe229f4e70af1b8ed04b',
    );
  }

  /// context is used to localization
  static void shareInvitingCode({
    required BuildContext context,
    required String studyName,
    required String invitingCode, }) async {
    logger.tryLog('kakao sharing');

    // check whether KakaoTalk Sharing is Available
    bool isSharable = await ShareClient.instance.isKakaoTalkSharingAvailable();

    if (!context.mounted) return;

    final textTemplate = _getTextTemplate(context, studyName, invitingCode);

    // #Case: Available = (Native App && KakaoTalk is Installed) || (Mobile's Web);
    if (isSharable) {
      logger.log('kakao sharing is available');

      try {
        Uri uri = await ShareClient.instance
            .shareDefault(template: textTemplate);
        await ShareClient.instance.launchKakaoTalk(uri);

        logger.successLog('kakao sharing');
      } on Exception catch (e) {
        logger.failLog('kakao sharing', e.toString());
      }
    }

    // #Case: Unavailable = (Native App && KakaoTalk is not Installed) || (Not mobile device);
    else {
      logger.log('kakao sharing is not available');

      try {
        // Access by Browser
        Uri shareUrl = await WebSharerClient.instance
            .makeDefaultUrl(template: textTemplate);
        await launchBrowserTab(shareUrl, popupOpen: true);

        logger.successLog('kakao sharing by web browser');
      } on Exception catch (e) {
        logger.failLog('kakao sharing', e.toString());
      }
    }
  }

  /// context is used to localization
  static TextTemplate _getTextTemplate(BuildContext context, String studyName, String invitingCode) {
    return TextTemplate(
      text: context.local.invitingMessage(invitingCode, studyName),
      buttonTitle: context.local.participate,
      link: Link(
        webUrl: Uri.parse('https://developers.kakao.com'), //< TODO: App Store link
        mobileWebUrl: Uri.parse('https://developers.kakao.com'), //< TODO: App Store link also
        iosExecutionParams: { "invitingCode": invitingCode, },
        androidExecutionParams: { "invitingCode": invitingCode, },
      ),
    );
  }
}