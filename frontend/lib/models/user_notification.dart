import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:groupstudy/models/notice.dart';
import 'package:groupstudy/models/round.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/notices/notice_detail_route.dart';
import 'package:groupstudy/routes/notices/notice_list_route.dart';
import 'package:groupstudy/routes/round_detail_route.dart';
import 'package:groupstudy/routes/studies/study_detail_route.dart';
import 'package:groupstudy/services/database_service.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:groupstudy/utilities/pageable.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:http/http.dart' as http;

class UserNotification {
  static Logger logger = Logger('UserNotification');

  final int id;
  final String title;
  final String message;
  final Map<String, dynamic> data;
  final DateTime createDate;
  bool isRead;

  UserNotification({
    required this.id,
    required this.title,
    required this.message,
    required this.data,
    required this.createDate,
    required this.isRead,
  });

  factory UserNotification.fromJson(Map<String, dynamic> json) {
    return UserNotification(
      id: json['id'],
      title: json['title'],
      message: json['message'],
      data: json['data'],
      isRead: json['isRead'],
      createDate: DateTime.parse(json["createDate"]),
    );
  }

  static Future<PageInfo<UserNotification>> getNotifications(
      int userId, int page, int pageSize) async {
    final response = await http.get(
      Uri.parse(
          '${DatabaseService.serverUrl}api/notifications/users/$userId/notifications?page=$page&size=$pageSize'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog(
        'get notification list (userId: $userId, page: $page, pageSize: $pageSize)',
        responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var notificationHistory = responseJson['data']['histories'];

      PageInfo<UserNotification> pageInfo = PageInfo.fromJson(
        notificationHistory,
        (json) => UserNotification.fromJson(json),
      );

      return pageInfo;
    }
  }

  static Future<bool> markAsRead(int userId, List<UserNotification> notifications, [bool readAll = false]) async {
    final List<int> notificationIds = notifications.map((n) => n.id).toList();
    final Map<String, dynamic> data = {
      'readAll': readAll,
      'notificationIds': notificationIds,
    };

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}/api/notifications/users/$userId/notifications'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('read notifications (userId: $userId, notificationIds: $notificationIds)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static void handleNotification(Map<String, dynamic> data) {
    switch (data['type']) {
      case 'study':
        _viewStudy(data);
        break;

      case 'round':
        _viewRound(data);
        break;

      case 'notice':
        _viewNotice(data);
        break;

      // [Fallthrough] : not implemented yet
      case 'others':
      default:
        // TODO: implement later
        break;
    }
  }

  static Future<Study?> _viewStudy(Map<String, dynamic> data) async {
    try {
      int studyId = int.parse(data['studyId']);

      Study study = await Study.getStudySummary(studyId);

      // View Study Detail
      Util.pushRouteByKey((context) => StudyDetailRoute(study: study));

      return study;
    } on Exception catch (e) {
      debugPrint(Util.getExceptionMessage(e));
    }

    return null;
  }

  static void _viewRound(Map<String, dynamic> data) async {
    // Visit Study Detail Route
    _viewStudy(data).then((study) async {
      if (study != null) {
        try {
          int roundId = int.parse(data['roundId']);
          int roundSeq = int.parse(data['roundSeq']);

          Round round = await Round.getDetail(roundId);

          // View Round Detail
          Util.pushRouteByKey(
            (context) => RoundDetailRoute(
              roundSeq: roundSeq,
              studyRound: StudyRound(round: round, study: study),
            ),
          );
        } on Exception catch (e) {
          debugPrint(Util.getExceptionMessage(e));
        }
      }
    });
  }

  static void _viewNotice(Map<String, dynamic> data) async {
    // Visit Study Detail Route
    _viewStudy(data).then((study) async {
      if (study != null) {
        try {
          int studyId = int.parse(data['studyId']);
          int noticeId = int.parse(data['noticeId']);

          NoticeSummary noticeSummary = NoticeSummary(
              notice: await Notice.getNotice(noticeId),
              commentCount: 0,
              pinYn: false);

          // Visit Notice List Route
          Util.pushRouteByKey((context) => NoticeListRoute(studyId: studyId));

          // View Notice Detail
          Util.pushRouteByKey((context) => NoticeDetailRoute(
              noticeSummary: noticeSummary,
              studyId: studyId,
              onDelete: Util.doNothing));
        } on Exception catch (e) {
          debugPrint(Util.getExceptionMessage(e));
        }
      }
    });
  }
}
