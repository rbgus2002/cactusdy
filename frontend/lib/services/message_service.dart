
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:groupstudy/models/notice.dart';
import 'package:groupstudy/models/round.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/notices/notice_detail_route.dart';
import 'package:groupstudy/routes/notices/notice_list_route.dart';
import 'package:groupstudy/routes/round_detail_route.dart';
import 'package:groupstudy/routes/studies/study_detail_route.dart';
import 'package:groupstudy/services/firebase_options.dart' as prod;
import 'package:groupstudy/services/firebase_options_dev.dart' as dev;
import 'package:groupstudy/services/logger.dart';
import 'package:groupstudy/services/notification_channel.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:package_info_plus/package_info_plus.dart';

class MessageService {
  MessageService._();

  static late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  static bool _isInitLocalNotification = false;

  static Logger logger = Logger('MessageService');

  static void init() async {
    await _initFCM();
    await _initLocalNotification();
    await _setupInteractedMessage(_MessageInteractionHandler._handleMessageInteraction);

    // if you want to see firebase messaging token, uncomment under line.
    logger.infoLog('firebase messaging token: ${await FirebaseMessaging.instance.getToken()}');
  }

  static Future<FirebaseOptions> _getCurrentPlatform() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String suffix = packageInfo.packageName.split('.').last;
    print(suffix);

    switch (suffix) {
      case 'dev':
        return dev.DefaultFirebaseOptions.currentPlatform;

      default:
        return prod.DefaultFirebaseOptions.currentPlatform;
    }
  }

  static Future<void> _initFCM() async {
    FirebaseOptions currentPlatform = await _getCurrentPlatform();
    await Firebase.initializeApp(options: currentPlatform);

    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    logger.infoLog('user granted permission: ${settings.authorizationStatus}');

    FirebaseMessaging.onMessage.listen(_foregroundHandler);

    FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  }

  static Future<void> _initLocalNotification() async {
    if (_isInitLocalNotification || kIsWeb) return;
    _isInitLocalNotification = true;

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    // Android init
    AndroidInitializationSettings initSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

    NotificationChannel.channels.forEach((key, channel) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);
    });

    // iOS init
    DarwinInitializationSettings initSettingsIOS =
      const DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true);

    InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification == null) return;

    String title = notification.title??"";
    String body = notification.body??"";

    logger.infoLog('notification: { title: $title, body: $body }');

    // Android : in our app, { channel id == title }
    var channel = NotificationChannel.channels[title]??
                  NotificationChannel.unknownChannel;

    // Android Details
    var androidDetails = AndroidNotificationDetails(
        channel.id, channel.name, importance: channel.importance, priority: Priority.max);

    // iOS Details
    var iOSDetails = const DarwinNotificationDetails(
        presentAlert: true);

    await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        title,
        body,
        NotificationDetails(
          android:  androidDetails,
          iOS:      iOSDetails
        ));
  }

  static Future<void> _foregroundHandler(RemoteMessage message) async {
    if (_isAndroid(message)) {
      _showNotification(message);
    }

    logger.infoLog('handling a foreground message ${message.messageId}');
  }

  static Future<void> _setupInteractedMessage(Function(RemoteMessage) messageHandler) async {
    RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      messageHandler(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(messageHandler);
  }

  // terminated : it's only work in release mode
  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    await _initLocalNotification();
    _showNotification(message);

    logger.infoLog('handling a background message ${message.messageId}');
  }

  static bool _isAndroid(RemoteMessage message) {
    return (message.notification?.android != null);
  }
}

class _MessageInteractionHandler {
  _MessageInteractionHandler._();

  static void _handleMessageInteraction(RemoteMessage message) {
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

      case 'notice':
        int studyId = int.parse(message.data['studyId']);
        int noticeId = int.parse(message.data['noticeId']);

        _viewNotice(studyId, noticeId);
        break;

      // [Fallthrough] : not implemented yet
      case 'others':
      default:
        // TODO: implement later
        break;
    }
  }

  static Future<Study?> _viewStudy(int studyId) async {
    try {
      Study study = await Study.getStudySummary(studyId);

      // View Study Detail
      Util.pushRouteByKey((context) =>
          StudyDetailRoute(study: study));

      return study;
    } on Exception catch (e) {
      debugPrint(Util.getExceptionMessage(e));
    }

    return null;
  }

  static void _viewRound(int studyId, int roundId, int roundSeq) async {
    // Visit Study Detail Route
    _viewStudy(studyId).then((study) async {
      if (study != null) {
        try {
          Round round = await Round.getDetail(roundId);

          // View Round Detail
          Util.pushRouteByKey((context) =>
              RoundDetailRoute(
                roundSeq: roundSeq,
                round: round,
                study: study,));
        } on Exception catch (e) {
          debugPrint(Util.getExceptionMessage(e));
        }
      }
    });
  }

  static void _viewNotice(int studyId, int noticeId) async {
    // Visit Study Detail Route
    _viewStudy(studyId).then((study) async {
      if (study != null) {
        try {
          NoticeSummary noticeSummary = NoticeSummary(
              notice: await Notice.getNotice(noticeId),
              commentCount: 0, pinYn: false);

          // Visit Notice List Route
          Util.pushRouteByKey((context) =>
              NoticeListRoute(
                  studyId: studyId));

          // View Notice Detail
          Util.pushRouteByKey((context) =>
              NoticeDetailRoute(
                  noticeSummary: noticeSummary,
                  studyId: studyId,
                  onDelete: Util.doNothing));
        } on Exception catch(e) {
          debugPrint(Util.getExceptionMessage(e));
        }
      }
    });
  }
}