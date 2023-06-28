import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class NoticeSummary {
  String title;
  String contents;
  String writerNickname;
  DateTime createDate;

  NoticeSummary({
    required this.title,
    required this.contents,
    required this.writerNickname,
    required this.createDate,
  });

  factory NoticeSummary.fromJson(Map<String, dynamic> json) {
    return NoticeSummary(
        title: json['title'],
        contents: json['contents'],
        writerNickname: json['writerNickname'],
        createDate: DateTime.parse(json['createDate']));
  }

  Map<String, dynamic> toJson() => {
    'title': title,
    'contents': contents,
    'writerNickname': writerNickname,
    'createDate' : createDate,
  };

  static Future<List<NoticeSummary>> getNoticeSummaryList(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}notices/list?studyId=$studyId'),
    );
    print('${DatabaseService.serverUrl}notices/list?studyId=$studyId');
    if (response.statusCode != 200) {
      throw Exception("Failed to load data");
    } else {
      print("User Data sent successfully");

      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['noticeList'];
      print(responseJson);

      return (responseJson as List).map((p) => NoticeSummary.fromJson(p)).toList();
    }
  }
}