import 'dart:convert';

import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Notice {
  static const titleMaxLength = 50;
  static const contentsMaxLength = 100;

  final int noticeId;
  final String title;
  final String content;

  final User writer;
  final DateTime writingTime;

  const Notice({
    required this.noticeId,
    required this.title,
    required this.content,
    required this.writer,
    required this.writingTime,
  });

  static Future<bool> createNotice(String title, String contents, int userId, int studyId) async {
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
        // 아 노티스 아이디가 필요하네..
        print("New notice is created successfully");
        return true;
      }
    }
    catch (e) {
      print(e);
      return false;
    }
  }
}