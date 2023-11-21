import 'dart:convert';
import 'package:group_study_app/models/notice.dart';
import 'package:group_study_app/models/sign_info.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class NoticeSummary {
  final Notice notice;
  final int commentCount;
  bool pinYn;

  NoticeSummary({
    required this.notice,
    required this.commentCount,
    required this.pinYn,
  });

  factory NoticeSummary.fromJson(Map<String, dynamic> json) {
    return NoticeSummary(
      notice: Notice.fromJson(json),
      commentCount: json['commentCount'],
      pinYn: (json['pinYn'] == 'Y'),
    );
  }

  static Future<List<NoticeSummary>> getNoticeSummaryList(int studyId, int offset, int pageSize) async {
    final response = await http.get(
        Uri.parse('${DatabaseService.serverUrl}api/notices/list?studyId=$studyId&offset=$offset&pageSize=$pageSize'),
        headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to load data");
    } else {
      print("successfully get Notice Summary List ($offset ~ ${offset + pageSize})");
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['notices']['noticeList'];

      return (responseJson as List).map((p) => NoticeSummary.fromJson(p)).toList();
    }
  }

  static Future<bool> switchNoticePin(int noticeId) async {
    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/notices/pin?noticeId=$noticeId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to change pin"); //< FIXME
    } else {
      String result = json.decode(
          utf8.decode(response.bodyBytes))['data']['pinYn'];
      return (result == 'Y');
    }
  }
}