import 'dart:convert';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class NoticeSummary {
  final int noticeId;
  final String title;
  final String contents;
  final String writerNickname;
  bool pinYn;
  final DateTime createDate;

  NoticeSummary({
    required this.noticeId,
    required this.title,
    required this.contents,
    required this.writerNickname,
    required this.createDate,
    required this.pinYn,
  });

  factory NoticeSummary.fromJson(Map<String, dynamic> json) {
    return NoticeSummary(
        noticeId: json['noticeId'],
        title: json['title'],
        contents: json['contents'],
        writerNickname: json['writerNickname'],
        pinYn: (json['pinYn'] == 'Y'),
        createDate: DateTime.parse(json['createDate']),
    );
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'contents': contents,
    'writerNickname': writerNickname,
    'createDate' : createDate,
  };

  static Future<List<NoticeSummary>> getNoticeSummaryList(int studyId) async {
    final response = await http.get(
        Uri.parse('${DatabaseService.serverUrl}notices/list?studyId=$studyId')
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to load data");
    } else {
      print("User Data sent successfully");

      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['noticeList'];

      return (responseJson as List).map((p) => NoticeSummary.fromJson(p)).toList();
    }
  }

  static Future<bool> switchNoticePin(int noticeId) async {
    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}notices/pin?noticeId=$noticeId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to change pin"); //< FIXME
    } else {
      print("pin is changed"); //< FIXME

      var responseJson = json.decode(
          utf8.decode(response.bodyBytes))['data']['pinYn'];
      return (responseJson == 'Y');
    }
  }
}