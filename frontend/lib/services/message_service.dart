
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:groupstudy/models/user_notification.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/services/firebase_options.dart' as prod;
import 'package:groupstudy/services/firebase_options_dev.dart' as dev;
import 'package:groupstudy/services/logger.dart';
import 'package:groupstudy/services/notification_channel.dart';
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

    logger.infoLog('firebase messaging token: ${await getFCMToken()}');
  }

  static Future<FirebaseOptions> _getCurrentPlatform() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String suffix = packageInfo.packageName.split('.').last;

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

  static Future<String?> getFCMToken() async {
    // Case: IOS-Simulator
    // return FirebaseMessaging.instance.getAPNSToken();

    return FirebaseMessaging.instance.getToken();
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

  static Future<bool> checkFCMToken() async {
    String? currentToken = await getFCMToken();
    String? savedToken = Auth.signInfo?.fcmToken;

    if ((currentToken == null) || (savedToken == null)) {
      return false;
    }

    logger.infoLog('current fcm token is different from saved one');
    return (currentToken.compareTo(savedToken) == 0);
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
    UserNotification.handleNotification(message.data);
  }
}
