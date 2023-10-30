
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:group_study_app/services/firebase_options.dart';

class MessageService {
  static late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;
  static bool _isInitLocalNotification = false;

  static void initMessageService() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    await _initFCM();
    await _initLocalNotification();

    print(await FirebaseMessaging.instance.getToken());
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

  void showFlutterNotification(RemoteMessage message) {
    /*
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null && !kIsWeb) {
      _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
          ),
        ),
      );
    }

     */
  }

  static Future<void> _initLocalNotification() async {
    if (_isInitLocalNotification || kIsWeb) return;

    _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    AndroidInitializationSettings initSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initSettingsIOS =
      const DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      );

    InitializationSettings initSettings = InitializationSettings(
      android: initSettingsAndroid,
      iOS: initSettingsIOS,
    );

    await _flutterLocalNotificationsPlugin.initialize(initSettings);

    _isInitLocalNotification = true;
  }

  static Future<void> _showNotification(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    if (notification == null) return;

    String title = notification!.title??"";
    String body = notification!.body??"";

    print('title : $title, body : $body');

    var androidDetails = AndroidNotificationDetails(title, body, importance: Importance.max, priority: Priority.max);
    var iOSDetails = DarwinNotificationDetails();

    var details = NotificationDetails(android: androidDetails, iOS: iOSDetails);

    await _flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        title,
        body,
        details);
  }

  static Future<void> _foregroundHandler(RemoteMessage message) async {
    _showNotification(message);

    print('Handling a foreground message ${message.messageId}');
  }

  // terminated : it's only work in release mode
  @pragma('vm:entry-point')
  static Future<void> _backgroundHandler(RemoteMessage message) async {
    await Firebase.initializeApp();
    await _initLocalNotification();
    _showNotification(message);

    print('Handling a background message ${message.messageId}');
  }
}