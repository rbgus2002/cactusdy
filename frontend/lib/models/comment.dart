import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Comment {
  final int userId;
  final String nickname;
  final String picture;

  final int commentId;
  final String contents;
  final DateTime createDate;
  List<Comment> replies;

  Comment({
    required this.userId,
    required this.nickname,
    required this.picture,

    required this.commentId,
    required this.contents,
    required this.createDate,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    List<Comment> replies = const [];
    if (json["replies"] != null) {
      replies = (json["replies"] as List).map((e) => Comment.fromJson(e)).toList();
    }

    return Comment(
      userId: json["userId"],
      nickname: json["nickname"],
      picture: json["picture"],
      commentId: json["commentId"],
      contents: json["contents"],
      createDate: DateTime.parse(json["createDate"]),
      replies: replies,
    );
  }

  static Future<List<Comment>> getComments(int noticeId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}comments?noticeId=$noticeId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to load comment");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['comments'];
      return (responseJson as List).map((e) => Comment.fromJson(e)).toList();
    }
  }
}