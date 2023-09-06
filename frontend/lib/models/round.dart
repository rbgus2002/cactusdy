

import 'dart:convert';

import 'package:group_study_app/models/round_participant_info.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Round {
  static const int nonAllocatedRoundId = -1;

  final int roundId;
  String? studyPlace;
  DateTime? studyTime;
  bool? isPlanned;
  final List<RoundParticipantInfo> roundParticipantInfos;

  Round({
    required this.roundId,
    this.studyPlace,
    this.studyTime,
    this.isPlanned,
    this.roundParticipantInfos = const [],
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    List<RoundParticipantInfo> roundParticipantInfos = (json['roundParticipantInfos'] as List).map(
            (r) => RoundParticipantInfo.fromJson(r)).toList();

    return Round(
      roundId: json['roundId'],
      studyPlace: json['studyPlace'],
      studyTime: (json['studyTime'] != null)? DateTime.parse(json['studyTime']) : null,
      isPlanned: json['isPlanned'],
      roundParticipantInfos: roundParticipantInfos,
    );
  }

  static Future<List<Round>> getRoundInfoResponses(int studyId) async {
    final response = await http.get(
        Uri.parse('${DatabaseService.serverUrl}rounds/list?studyId=$studyId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to get RoundInfos");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['roundList'];

      return (responseJson as List).map((r) => Round.fromJson(r)).toList();
    }
  }
}