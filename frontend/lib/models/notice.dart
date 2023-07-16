import 'dart:convert';

import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Notice {
  static const titleMaxLength = 50;
  static const contentsMaxLength = 100;
  static const NOTICE_CREATION_ERROR = -1;

  final int noticeId;
  final String title;
  final String contents;
  final String writerNickname;
  final int checkNoticeCount;
  final DateTime createDate;
  int commentCount;
  bool read;

  Notice({
    required this.noticeId,
    required this.title,
    required this.contents,
    required this.writerNickname,
    required this.checkNoticeCount,
    required this.createDate,
    required this.commentCount,
    required this.read,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      noticeId: json["noticeId"],
      title: json["title"],
      contents: json["contents"],
      writerNickname: json["writerNickname"],
      checkNoticeCount: json["checkNoticeCount"],
      createDate: DateTime.parse(json["createDate"]),
      commentCount: json["commentCount"],
      read: json["read"],
    );
  }

  static Future<Notice> getNotice(int noticeId, int userId) async {
      final response = await http.get(Uri.parse('${DatabaseService.serverUrl}notices?noticeId=$noticeId&userId=$userId'));

      if (response.statusCode != DatabaseService.SUCCESS_CODE) {
        throw Exception("Failed to load notice");
      } else {
        var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['noticeInfo'];
        return Notice.fromJson(responseJson);
      }
  }

  static Future<int> createNotice(String title, String contents, int userId, int studyId) async {
    try {
      Map<String, dynamic> data = {
        'title': title,
        'contents': contents,
        'userId': userId,
        'studyId': studyId,
      };

      final response = await http.post(
          Uri.parse('${DatabaseService.serverUrl}notices'),
          headers: DatabaseService.header,
          body: json.encode(data),
      );

      if (response.statusCode != DatabaseService.SUCCESS_CODE) {
        throw Exception("Failed to create new notice");
      } else {
        int newStudyId = json.decode(response.body)['data']['noticeId'];
        print("New notice is created successfully");
        return newStudyId;
      }
    }
    catch (e) {
      print(e);
      return NOTICE_CREATION_ERROR;
    }
  }

  static Future<bool> switchCheckNotice(int noticeId, int userId) async {
    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}notices/check?noticeId=$noticeId&userId=$userId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Fail to switch check notice");
    } else {
      String isChecked = json.decode(response.body)['data']["isChecked"];
      return (isChecked == "Y");
    }
  }
}