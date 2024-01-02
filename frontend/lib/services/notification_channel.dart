

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationChannel {
  NotificationChannel._();

  // channel id   : unique id for distinction (inside)
  // channel name : user visible name (display)

  static const Map<String, AndroidNotificationChannel> channels = {
    '공지사항': AndroidNotificationChannel(
        '공지사항', // channel id
        '공지사항', // channel name
        description: '스터디의 새로운 공지사항, 공지사항의 새로운 댓글 알림',
        importance: Importance.max,),

    '콕찌르기': AndroidNotificationChannel(
        '콕찌르기', // channel id
        '콕찌르기', // channel name
        description: '스터디 멤버의 콕찌르기 알림',
        importance: Importance.max,),

    '회차': AndroidNotificationChannel(
        '회차', // channel id
        '회차', // channel name
        description: '새로운 회차 생성, 예정된 회차 알림',
        importance: Importance.max,),

    '과제': AndroidNotificationChannel(
        '과제', // channel id
        '과제', // channel name
        description: '스터디 멤버의 과제 수행 알림',
        importance: Importance.high,),
  };

  static const AndroidNotificationChannel unknownChannel = AndroidNotificationChannel(
      'unknown',
      '알 수 없는 알림',
      description: '올바르게 분류되지 않은 알림',
      importance: Importance.defaultImportance);
}