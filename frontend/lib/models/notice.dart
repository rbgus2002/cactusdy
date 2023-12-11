import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Notice {
  // string length limits
  static const titleMaxLength = 50;
  static const contentsMaxLength = 100;

  // state code
  static const noticeCreationError = -1;

  final int noticeId;
  String title;
  String contents;
  final String writerNickname;
  final int writerId;
  final DateTime createDate;
  int checkNoticeCount;
  bool read;

  Notice({
    required this.noticeId,
    required this.title,
    required this.contents,
    required this.writerNickname,
    required this.writerId,
    required this.createDate,
    required this.checkNoticeCount,
    required this.read,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      noticeId: json["noticeId"],
      title: json["title"],
      contents: json["contents"],
      writerNickname: json["writerNickname"],
      checkNoticeCount: json["readCount"]??0,
      createDate: DateTime.parse(json["createDate"]),
      writerId: json["writerId"],
      read: json["read"],
    );
  }

  static Future<Notice> getNotice(int noticeId) async {
      final response = await http.get(
        Uri.parse('${DatabaseService.serverUrl}api/notices?noticeId=$noticeId'),
        headers: DatabaseService.getAuthHeader(),
      );

      if (response.statusCode != DatabaseService.successCode) {
        throw Exception("Failed to load notice");
      } else {
        //print(json.decode(utf8.decode(response.bodyBytes)));
        var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['noticeInfo'];
        return Notice.fromJson(responseJson);
      }
  }

  static Future<Notice> createNotice(String title, String contents, int studyId) async {
    Map<String, dynamic> data = {
      'title': title,
      'contents': contents,
      'studyId': studyId,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/notices'),
      headers: DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to create new notice");
    } else {
      print("success to create New notice");
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['noticeInfo'];
      return Notice.fromJson(responseJson);
    }
  }

  static Future<bool> updateNotice(Notice notice) async {
    Map<String, dynamic> data = {
      'title': notice.title,
      'contents': notice.contents,
    };

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/notices?noticeId=${notice.noticeId}'),
      headers: DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(response.body);
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      bool success = responseJson['success'];
      if (success) print("Success to update task detail"); //< FIXME
      return success;
    }
  }

  static Future<bool> deleteNotice(int noticeId) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/notices?noticeId=$noticeId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Fail to delete notice");
    } else {
      print(response.body);
      bool result = json.decode(response.body)['success'];
      return result;
    }
  }

  static Future<bool> switchCheckNotice(int noticeId) async {
    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/notices/check?noticeId=$noticeId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to switch check notice");
    } else {
      String isChecked = json.decode(response.body)['data']["isChecked"];
      return (isChecked == "Y");
    }
  }

  static Future<List<String>> getCheckUserImageList(int noticeId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/notices/users/images?noticeId=$noticeId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to get Checked User Images");
    } else {
      var responseJson = json.decode(response.body)['data']['userImageList'];
      return (responseJson as List).map((e) =>
          (e == null) ? "" : e as String).toList();
    }
  }
}