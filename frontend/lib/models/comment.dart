import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Comment {
  static const commentCreationError = -1;
  static const commentWithNoParent = -1;

  final int userId;
  final String nickname;
  final String picture;

  final int commentId;
  final String contents;
  final DateTime createDate;

  List<Comment> replies;

  final bool isDeleted;

  Comment({
    required this.userId,
    required this.nickname,
    required this.picture,

    required this.commentId,
    required this.contents,
    required this.createDate,

    this.replies = const [],

    this.isDeleted = false,
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

      isDeleted: false,
    );
  }

  static Future<List<Comment>> getComments(int noticeId) async {
    print("this is called");
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

  static Future<int> writeComment(int userId, int noticeId, String contents, int? parentCommentId) async {
    Map<String, dynamic> data = {
      'userId': userId,
      'noticeId': noticeId,
      'contents': contents,
      'parentCommentId': parentCommentId
    };

    try {
      final response = await http.post(
        Uri.parse('${DatabaseService.serverUrl}comments'),
        headers: DatabaseService.header,
        body: json.encode(data),
      );

      if (response.statusCode != DatabaseService.SUCCESS_CODE) {
        throw Exception("Failed to write new comment");
      } else {
        int newCommentId = json.decode(response.body)['data']['commentId'];
        return newCommentId;
      }
    }
    catch (e) {
      print(e);
      return commentCreationError;
    }
  }

  static Future<bool> deleteComment(int commentId) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}comments?commentId=$commentId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Fail to delete comment");
    } else {
      print(response.body);
      bool result = json.decode(response.body)['success'];
      return result;
    }
  }
}