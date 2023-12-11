
import 'dart:convert';

import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class StudyInfo {
  final Study study;
  final List<TaskGroup> taskGroups;
  final List<String> profileImages; //< FIXME : { picture, statusTag } -> picture only API modify
  final int roundSeq;
  final Round round;
  
  const StudyInfo({
    required this.study,
    required this.taskGroups,
    required this.profileImages,
    required this.roundSeq,
    required this.round,
  });
  
  factory StudyInfo.fromJson(Map<String, dynamic> json) {
    return StudyInfo(
      study: Study.fromJson(json),
      taskGroups: ((json['taskGroups']??[]) as List).map((t)
        => TaskGroup.fromJson(t, json['roundParticipantId'])).toList(),
      profileImages: ((json['profiles']??[]) as List).map((p)
        => (p['picture']??"") as String).toList(),
      roundSeq: json['roundSeq'],
      round: Round.fromJson(json),
    );
  }
  
  static Future<List<StudyInfo>> getStudies() async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies/list'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to get Studies");
    } else {
      print("Success to get Study Information");
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['studyInfos'];
      return (responseJson as List).map((s) => StudyInfo.fromJson(s)).toList();
    }
  }
}