
import 'dart:convert';
import 'dart:ui';

import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class Study {
  // string length limits
  static const int studyNameMaxLength = 30;
  static const int studyDetailMaxLength = 40;

  // const values
  static const int invitingCodeLength = 6;

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
      color : Color(int.parse((json['color'] as String).substring(2), radix: 16)),
      hostId: json['hostUserId'],
    );
  }

  static Future<Study> getStudySummary(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies?studyId=$studyId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to get Study Summary");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['studySummary'];
      return Study.fromJson(responseJson);
    }
  }

  static Future<Map<String, dynamic>> createStudy({
    required String studyName,
    required String studyDetail,
    required Color studyColor,
    required XFile? studyImage
  }) async {
    final request = http.MultipartRequest('POST',
      Uri.parse('${DatabaseService.serverUrl}api/studies'),);

    request.headers.addAll(DatabaseService.getAuthHeader());

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

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      print('success to create study');
      return responseJson['data']['study'];
    }
  }

  static Future<int> joinStudyByInvitingCode(String invitingCode) async {
    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/studies/participants?inviteCode=$invitingCode'),
      headers: DatabaseService.getAuthHeader(),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      int studyId = json.decode(utf8.decode(response.bodyBytes))['data']['studyId'];
      print('success to join a study');
      return studyId;
    }
  }

  static Future<bool> leaveStudy(Study study) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/studies/participants?studyId=${study.studyId}'),
      headers: DatabaseService.getAuthHeader(),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      bool result = json.decode(response.body)['success'];
      if (result) print("success to leave study");
      return result;
    }
  }

  static Future<bool> updateStudy(Study updatedStudy, XFile? studyImage) async {
    final request = http.MultipartRequest('PATCH',
      Uri.parse('${DatabaseService.serverUrl}api/studies/${updatedStudy.studyId}'),);

    request.headers.addAll(DatabaseService.getAuthHeader());

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

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      print('sucess to update study');
      return responseJson['success'];
    }
  }

  static Future<String> getStudyInvitingCode(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies/$studyId/inviteCode'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to get Study inviting code");
    } else {
      var invitingCode = json.decode(utf8.decode(response.bodyBytes))['data']['inviteCode'];
      print('success to get inviting code($invitingCode)');
      return invitingCode;
    }
  }

  static Future<List<ParticipantSummary>> getMemberProfileImages(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies/participants/summary?studyId=$studyId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Fail to get Participants data (studyId = $studyId)");
    } else {
      print("successfully get Participants data (studyId = $studyId)");

      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['participantSummaryList'];

      return (responseJson as List).map((p) => ParticipantSummary.fromJson(p)).toList();
    }
  }
}

class ParticipantSummary {
  final int userId;
  final String picture;
  final String nickname;

  ParticipantSummary({
    required this.userId,
    required this.picture,
    required this.nickname,
  });

  factory ParticipantSummary.fromJson(Map<String, dynamic> json) {
    return ParticipantSummary(
      userId: json['userId']??User.nonAllocatedUserId,
      picture: json['picture']??"",
      nickname: json['nickname']??"",
    );
  }
}