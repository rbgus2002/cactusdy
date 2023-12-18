
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:group_study_app/services/firebase_options.dart';
import 'package:group_study_app/services/notification_channel.dart';

class MessageService {
  MessageService._();

  static late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  static bool _isInitLocalNotification = false;

  static void initMessageService() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await _initFCM();
    await _initLocalNotification();

    // if you want to see firebase messaging token, uncomment under line.
    print('Firebase Messaging Token : ${await FirebaseMessaging.instance.getToken()}');
  }

  static Future<void> _initFCM() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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

    print('User granted permission: ${settings.authorizationStatus}');

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

    String title = notification!.title??"";
    String body = notification!.body??"";
    print('notification : { title : $title, body : $body }');

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

    print('Handling a foreground message ${message.messageId}');
  }

  static Future<void> setupInteractedMessage(Function(RemoteMessage) messageHandler) async {
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

    print('Handling a background message ${message.messageId}');
  }

  static bool _isAndroid(RemoteMessage message) {
    return (message.notification?.android != null);
  }
}