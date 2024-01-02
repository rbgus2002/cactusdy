import 'dart:convert';

import 'package:groupstudy/services/database_service.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:http/http.dart' as http;

class Notice {
  // string length limits
  static const titleMaxLength = 50;
  static const contentsMaxLength = 500;

  // state code
  static const noticeCreationError = -1;

  static Logger logger = Logger('Notice');

  final int writerId;
  final String writerNickname;
  final DateTime createDate;

  final int noticeId;
  String title;
  String contents;
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
        headers: await DatabaseService.getAuthHeader(),
      );

      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      logger.resultLog('get notice (noticeId: $noticeId)', responseJson);

      if (response.statusCode != DatabaseService.successCode) {
        throw Exception(responseJson['message']);
      } else {
        var noticeInfoJson = responseJson['data']['noticeInfo'];
        return Notice.fromJson(noticeInfoJson);
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
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('create notice (studyId: $studyId, title: $title)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var newNoticeInfoJson = responseJson['data']['noticeInfo'];
      logger.infoLog('created noticeId: ${newNoticeInfoJson['noticeId']}');

      return Notice.fromJson(newNoticeInfoJson);
    }
  }

  static Future<bool> updateNotice(Notice notice) async {
    Map<String, dynamic> data = {
      'title': notice.title,
      'contents': notice.contents,
    };

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/notices?noticeId=${notice.noticeId}'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('update notice (noticeId: ${notice.noticeId})', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<bool> deleteNotice(int noticeId) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/notices?noticeId=$noticeId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('delete notice (noticeId: $noticeId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<bool> switchCheckNotice(int noticeId) async {
    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/notices/check?noticeId=$noticeId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('switch check notice (noticeId: $noticeId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      String isChecked = responseJson['data']["isChecked"];
      Notice.logger.infoLog('switch check notice as $isChecked');

      return (isChecked == "Y");
    }
  }

  static Future<List<String>> getCheckUserImageList(int noticeId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/notices/users/images?noticeId=$noticeId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('get notice checker\'s profile images (noticeId: $noticeId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var profileImagesJson = json.decode(response.body)['data']['userImageList'];

      List<String> profileImages = (profileImagesJson as List).map((picture) =>
              (picture == null) ? "" : picture as String).toList();

      return profileImages;
    }
  }
}

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

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    Notice.logger.resultLog('get notice summary list [$offset:${offset + pageSize}]', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var noticeListJson = responseJson['data']['notices']['noticeList'];

      List<NoticeSummary> noticeList = (noticeListJson as List).map((p)
          => NoticeSummary.fromJson(p)).toList();

      return noticeList;
    }
  }

  static Future<bool> switchNoticePin(int noticeId) async {
    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/notices/pin?noticeId=$noticeId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    Notice.logger.resultLog('switch notice pin (noticeId: $noticeId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      bool result = (responseJson['data']['pinYn'] == 'Y');
      Notice.logger.infoLog('switch notice\'s pin as $result');

      return result;
    }
  }
}