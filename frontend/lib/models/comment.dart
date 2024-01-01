import 'dart:convert';

import 'package:groupstudy/services/database_service.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:http/http.dart' as http;

class Comment {
  // string length limit
  static const commentMaxLength = 255;

  // state code
  static const noReplyTarget = -1;

  static Logger logger = Logger('Comment');

  final int userId;
  final String nickname;
  final String picture;

  final int commentId;
  final String contents;
  final DateTime createDate;

  final bool deleteYn;
  final List<Comment> replies;

  Comment({
    required this.userId,
    required this.nickname,
    required this.picture,

    required this.commentId,
    required this.contents,
    required this.createDate,

    this.deleteYn = false,
    this.replies = const [],
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    List<Comment> replies = ((json["replies"]??[]) as List).map(
            (reply) => Comment.fromJson(reply)).toList();

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

  static Future<CommentsInfo> getComments(int noticeId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/comments?noticeId=$noticeId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('get comments (noticeId: $noticeId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var commentInfoJson = responseJson['data']['comments'];
      return CommentsInfo.fromJson(commentInfoJson);
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
    logger.resultLog('write comment (noticeId: $noticeId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      int newCommentId = responseJson['data']['commentId'];
      logger.infoLog('written commentId: $newCommentId');

      return newCommentId;
    }
  }

  static Future<bool> deleteComment(int commentId) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/comments?commentId=$commentId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('delete comment (commentId: $commentId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }
}

class CommentsInfo {
  final int count;
  final List<Comment> comments;

  CommentsInfo({
    required this.count,
    required this.comments,
  });

  factory CommentsInfo.fromJson(Map<String, dynamic> json) {
    return CommentsInfo(
      count: json['commentCount'],
      comments: ((json['commentInfos']??[]) as List).map(
              (e) => Comment.fromJson(e)).toList());
  }
}