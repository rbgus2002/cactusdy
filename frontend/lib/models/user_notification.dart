import 'package:flutter/cupertino.dart';
import 'package:groupstudy/models/notice.dart';
import 'package:groupstudy/models/round.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/notices/notice_detail_route.dart';
import 'package:groupstudy/routes/notices/notice_list_route.dart';
import 'package:groupstudy/routes/round_detail_route.dart';
import 'package:groupstudy/routes/studies/study_detail_route.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:groupstudy/utilities/util.dart';

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
