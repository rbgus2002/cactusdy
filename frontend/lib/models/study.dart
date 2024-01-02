
import 'dart:convert';
import 'dart:ui';

import 'package:groupstudy/models/round.dart';
import 'package:groupstudy/models/task.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/services/database_service.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:groupstudy/utilities/color_util.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class Study {
  // string length limits
  static const int studyNameMaxLength = 14;
  static const int studyDetailMaxLength = 20;

  // state code
  static const int nonAllocatedStudyId = -1;

  // const values
  static const int invitingCodeLength = 6;

  static Logger logger = Logger('Study');

  final int studyId;
  String studyName;
  String detail;
  String picture;
  Color color;
  int hostId;

  Study({
    required this.studyId,
    required this.studyName,
    required this.detail,
    required this.picture,
    required this.color,
    required this.hostId
  });

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      studyId: json['studyId'],
      studyName: json['studyName'],
      detail: json['detail'],
      picture: json['picture']??"",
      color : ColorUtil.fromJson(json),
      hostId: json['hostUserId'],
    );
  }

  static Future<Study> getStudySummary(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies?studyId=$studyId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('get study summary (studyId: $studyId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var studyJson = responseJson['data']['studySummary'];
      return Study.fromJson(studyJson);
    }
  }

  static Future<bool> createStudy({
    required String studyName,
    required String studyDetail,
    required Color studyColor,
    required XFile? studyImage,
    required Function(int, String) onCreate,
  }) async {
    final request = http.MultipartRequest('POST',
      Uri.parse('${DatabaseService.serverUrl}api/studies'),);

    request.headers.addAll(await DatabaseService.getAuthHeader());

    Map<String, dynamic> data = {
      'studyName': studyName,
      'detail': studyDetail,
      'color': '0x${studyColor.value.toRadixString(16).toUpperCase()}',
    };

    request.files.add(http.MultipartFile.fromString(
      'dto', jsonEncode(data), contentType: MediaType("application","json"),));

    if (studyImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profileImage', studyImage.path));
    }

    final response = await request.send();
    final responseJson = jsonDecode(await response.stream.bytesToString());
    logger.resultLog('create study', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      int newStudyId = responseJson['data']['study']['studyId'];
      String invitingCode = responseJson['data']['study']['inviteCode'];
      logger.infoLog('created study\'s studyId: $newStudyId');
      
      onCreate(newStudyId, invitingCode);
      return responseJson['success'];
    }
  }

  static Future<int> joinStudyByInvitingCode(String invitingCode) async {
    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/studies/participants?inviteCode=$invitingCode'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('join study by inviting code(invitingCode: $invitingCode)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      int studyId = responseJson['data']['studyId'];
      return studyId;
    }
  }

  static Future<bool> leaveStudy(Study study) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/studies/participants?studyId=${study.studyId}'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('leave study (studyId: ${study.studyId})', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<bool> updateStudy(Study updatedStudy, XFile? studyImage) async {
    final request = http.MultipartRequest('PATCH',
      Uri.parse('${DatabaseService.serverUrl}api/studies/${updatedStudy.studyId}'),);

    request.headers.addAll(await DatabaseService.getAuthHeader());

    Map<String, dynamic> data = {
      'studyName': updatedStudy.studyName,
      'detail': updatedStudy.detail,
      'color': '0x${updatedStudy.color.value.toRadixString(16).toUpperCase()}',
      'hostUserId': updatedStudy.hostId,
    };

    request.files.add(http.MultipartFile.fromString(
        'dto', jsonEncode(data), contentType: MediaType("application","json"),));

    if (studyImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profileImage', studyImage.path));
    }

    final response = await request.send();
    final responseJson = jsonDecode(await response.stream.bytesToString());
    logger.resultLog('update study (studyId: ${updatedStudy.studyId})', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<String> getStudyInvitingCode(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies/$studyId/inviteCode'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('get study inviting code', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to get Study inviting code");
    } else {
      var invitingCode = responseJson['data']['inviteCode'];
      logger.infoLog('inviting code: $invitingCode');

      return invitingCode;
    }
  }

  static Future<List<UserProfileSummary>> getMemberProfileSummaries(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies/participants/summary?studyId=$studyId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('get member profile images (studyId: $studyId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var profileSummariesJson = json.decode(utf8.decode(response.bodyBytes))['data']['participantSummaryList'];

      List<UserProfileSummary> profileSummaries = (profileSummariesJson as List).map((p) =>
          UserProfileSummary.fromJson(p)).toList();
      logger.infoLog('member profile images length: ${profileSummaries.length}');

      return profileSummaries;
    }
  }

  static int getInvitingCode(String uriStr) {
    String invitingCode = uriStr.substring(uriStr.length - Study.invitingCodeLength);
    return int.parse(invitingCode);
  }
}

class StudySummary {
  final Study study;
  final List<TaskGroup> taskGroups;
  final List<String> profileImages;
  final int roundSeq;
  final Round round;

  const StudySummary({
    required this.study,
    required this.taskGroups,
    required this.profileImages,
    required this.roundSeq,
    required this.round,
  });

  factory StudySummary.fromJson(Map<String, dynamic> json) {
    List<TaskGroup> taskGroups = ((json['taskGroups']??[]) as List).map((t)
        => TaskGroup.fromJson(t, json['roundParticipantId'])).toList();

    List<String> profileImages = ((json['profiles']??[]) as List).map((p)
        => (p['picture']??"") as String).toList();

    return StudySummary(
      study: Study.fromJson(json),
      taskGroups: taskGroups,
      profileImages: profileImages,
      roundSeq: json['roundSeq'],
      round: Round.fromJson(json),
    );
  }

  static Future<List<StudySummary>> getStudies() async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies/list'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    Study.logger.resultLog('get studies', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var studySummariesJson = json.decode(utf8.decode(response.bodyBytes))['data']['studyInfos'];

      List<StudySummary> studySummaries = (studySummariesJson as List).map((s) =>
          StudySummary.fromJson(s)).toList();

      return studySummaries;
    }
  }
}