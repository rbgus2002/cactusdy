

import 'dart:convert';

import 'package:group_study_app/models/round_participant_info.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Round {
  // string length limits
  static const detailMaxLength = 100;

  // state code
  static const int nonAllocatedRoundId = -1;

  final int roundId;
  String? studyPlace;
  DateTime? studyTime;
  bool? isPlanned;
  String? detail;

  final List<RoundParticipantInfo> roundParticipantInfos;

  Round({
    required this.roundId,
    this.studyPlace,
    this.studyTime,
    this.isPlanned,
    this.detail,
    this.roundParticipantInfos = const[],
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    List<RoundParticipantInfo> roundParticipantInfos = [];
    if (json['roundParticipantInfos'] != null) {
      roundParticipantInfos = (json['roundParticipantInfos'] as List).map(
              (r) => RoundParticipantInfo.fromJson(r)).toList();
    }

    return Round(
      roundId: json['roundId'],
      studyPlace: json['studyPlace'],
      studyTime: (json['studyTime'] != null)? DateTime.parse(json['studyTime']) : null,
      isPlanned: json['isPlanned'],
      detail: json['detail'],
      roundParticipantInfos: roundParticipantInfos,
    );
  }

  static Future<bool> updateAppointment(Round round) async {
    String? studyTime = (round.studyTime != null)?
      DateFormat('yyyy-MM-dd HH:mm').format(round.studyTime!) : null;

    Map<String, dynamic> data = {
      'studyTime': studyTime,
      'studyPlace': round.studyPlace,
    };

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}rounds?roundId=${round.roundId}'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to update round detail");
    } else {
      bool success = json.decode(response.body)['success'];
      if(success) print("SUCCESS!!"); //< FIXME
      return success;
    }
  }

  static Future<Round> getDetail(int roundId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}rounds/details?roundId=$roundId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to get round detail");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['detail'];

      return Round.fromJson(responseJson);
    }
  }


  static Future<bool> updateDetail(int roundId, String detail) async {
    Map<String, dynamic> data = {
      'detail': detail,
    };

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}rounds/details?roundId=$roundId'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to update round detail");
    } else {
      bool success = json.decode(response.body)['success'];
      if(success) print("SUCCESS!!");
      return success;
    }
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