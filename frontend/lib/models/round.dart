

import 'dart:convert';

import 'package:group_study_app/models/round_participant_info.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Round {
  // string length limits
  static const int detailMaxLength = 255;
  static const int placeMaxLength = 15;

  // state code
  static const int nonAllocatedRoundId = -1;

  int roundId;
  String studyPlace;
  DateTime? studyTime;
  String? detail;

  final List<RoundParticipantInfo>? roundParticipantInfos;

  Round({
    required this.roundId,
    this.studyPlace = "",
    this.studyTime,
    this.detail,
    this.roundParticipantInfos,
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    List<RoundParticipantInfo>? roundParticipantInfos;
    if (json['roundParticipantInfos'] != null) {
      roundParticipantInfos = (json['roundParticipantInfos'] as List).map(
              (r) => RoundParticipantInfo.fromJson(r)).toList();
    }

    return Round(
      roundId: json['roundId']??nonAllocatedRoundId,
      studyPlace: json['studyPlace']??"",
      studyTime: (json['studyTime'] != null)? DateTime.parse(json['studyTime']) : null,
      detail: json['detail'],
      roundParticipantInfos: roundParticipantInfos,
    );
  }

  static Future<bool> createRound(Round round, int studyId) async {
    String? studyTime = (round.studyTime != null)?
      DateFormat('yyyy-MM-dd HH:mm').format(round.studyTime!) : null;

    Map<String, dynamic> data = {
      'studyTime': studyTime,
      'studyPlace': round.studyPlace,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/rounds?studyId=$studyId'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to create round");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      bool success = responseJson['success'];
      if(success) {
        round.roundId = responseJson['data']['roundId'];
        print("SUCCESS!!"); //< FIXME
      }
      return success;
    }
  }

  static Future<bool> deleteRound(int roundId) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/rounds?roundId=$roundId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(json.decode(utf8.decode(response.bodyBytes))['message']);
    } else {
      bool success = json.decode(response.body)['success'];
      return success;
    }
  }

  static Future<bool> updateAppointment(Round round) async {
    if (round.roundId == Round.nonAllocatedRoundId) return false;

    String? studyTime = (round.studyTime != null)?
      DateFormat('yyyy-MM-dd HH:mm').format(round.studyTime!) : null;

    Map<String, dynamic> data = {
      'studyTime': studyTime,
      'studyPlace': round.studyPlace,
    };

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/rounds?roundId=${round.roundId}'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to update round appointment");
    } else {
      bool success = json.decode(response.body)['success'];
      if(success) print("Success to update round appointment"); //< FIXME
      return success;
    }
  }

  static Future<Round> getDetail(int roundId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/rounds/details?roundId=$roundId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
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
      Uri.parse('${DatabaseService.serverUrl}api/rounds/details?roundId=$roundId'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to update round detail");
    } else {
      bool success = json.decode(response.body)['success'];
      if(success) print("SUCCESS!!");
      return success;
    }
  }

  static Future<List<Round>> getRoundInfoResponses(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/rounds/list?studyId=$studyId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to get RoundInfos");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['roundList'];

      return (responseJson as List).map((r) => Round.fromJson(r)).toList();
    }
  }
}