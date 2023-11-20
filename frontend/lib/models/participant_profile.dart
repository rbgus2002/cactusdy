
import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;
import 'package:group_study_app/models/study_tag.dart';
import 'package:group_study_app/models/user.dart';

class ParticipantProfile {
  final User participant;
  final List<StudyTag> studyTags;
  final List attendanceRate;
  final int doneRate;

  ParticipantProfile({
    required this.participant,
    required this.studyTags,
    required this.attendanceRate,
    required this.doneRate,
  });

  factory ParticipantProfile.fromJson(Map<String, dynamic> json) {
    print(json['statusTagInfoList']);
    return ParticipantProfile(
      participant: User.fromJson(json),
      studyTags: (json['studyColorInfoList'] as List).map((studyTag) =>
          StudyTag.fromJson(studyTag)).toList(),
      attendanceRate: json['statusTagInfoList'],
      doneRate: json['doneRate'],
    );
  }

  static Future<ParticipantProfile> getParticipantProfile(int userId, int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies/participants?userId=$userId&studyId=$studyId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception();
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['participant'];
      print('success to get participant profile');
      return ParticipantProfile.fromJson(responseJson);
    }
  }
}