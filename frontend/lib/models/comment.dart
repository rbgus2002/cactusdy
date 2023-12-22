import 'dart:convert';

import 'package:groupstudy/services/database_service.dart';
import 'package:http/http.dart' as http;

class Comment {
  // string length limit
  static const commentMaxLength = 255;

  // state code
  static const noReplyTarget = -1;

  final int userId;
  final String nickname;
  final String picture;

  final int commentId;
  final String contents;
  final DateTime createDate;

  List<Comment> replies;

  final bool deleteYn;

  Comment({
    required this.userId,
    required this.nickname,
    required this.picture,

    required this.commentId,
    required this.contents,
    required this.createDate,

    this.replies = const [],

    this.deleteYn = false,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    List<Comment> replies = const [];
    if (json["replies"] != null) {
      replies = (json["replies"] as List).map((e) => Comment.fromJson(e)).toList();
    }

    return Comment(
      userId: json["userId"],
      nickname: json["nickname"],
      picture: json["picture"]??"",
      commentId: json["commentId"],
      contents: json["contents"],
      createDate: DateTime.parse(json["createDate"]),
      deleteYn: (json["deleteYn"] == 'Y'),
      replies: replies,
    );
  }

  static Future<Map<String, dynamic>> getComments(int noticeId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/comments?noticeId=$noticeId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to load comment");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['comments'];

      Map<String, dynamic> data = {
        'commentCount': responseJson['commentCount'],
        'commentInfos': (responseJson['commentInfos'] as List).map((e) => Comment.fromJson(e)).toList()
      };

      return data;
    }
  }

  static Future<int> writeComment(int noticeId, String contents, int? parentCommentId) async {
    Map<String, dynamic> data = {
      'noticeId': noticeId,
      'contents': contents,
      'parentCommentId': parentCommentId
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/comments'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      int newCommentId = responseJson['data']['commentId'];
      return newCommentId;
    }
  }

  static Future<bool> deleteComment(int commentId) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/comments?commentId=$commentId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Fail to delete comment");
    } else {
      bool result = json.decode(response.body)['success'];
      if (result) print('success to delete comment');
      return result;
    }
  }
}