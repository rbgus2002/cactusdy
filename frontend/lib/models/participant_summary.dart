import 'dart:convert';

import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

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

  static Future<List<ParticipantSummary>> getParticipantsProfileImageList(int studyId) async {
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
}