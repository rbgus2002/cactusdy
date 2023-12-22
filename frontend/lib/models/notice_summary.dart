import 'dart:convert';

import 'package:groupstudy/models/notice.dart';
import 'package:groupstudy/services/database_service.dart';
import 'package:http/http.dart' as http;

class NoticeSummary {
  Notice notice;
  int commentCount;
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
        headers: await DatabaseService.getAuthHeader(),
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
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      print('success to switch notice\'s pin as ${responseJson['data']['pinYn']}');
      bool result = (responseJson['data']['pinYn'] == 'Y');
      return result;
    }
  }
}