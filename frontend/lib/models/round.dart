

import 'dart:convert';

import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/services/database_service.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class Round {
  // string length limits
  static const int detailMaxLength = 255;
  static const int placeMaxLength = 15;

  // state code
  static const int nonAllocatedRoundId = -1;

  // const value
  static const int roundLimitedCount = 60;

  static Logger logger = Logger('Round');

  int roundId;
  String studyPlace;
  DateTime? studyTime;
  String? detail; //< TODO: extract detail from round

  final List<UserProfileSummary>? participantProfileSummaries;

  Round({
    required this.roundId,
    this.studyPlace = "",
    this.studyTime,
    this.detail,
    this.participantProfileSummaries,
  });

  factory Round.fromJson(Map<String, dynamic> json) {
    DateTime? studyTime = (json['studyTime'] != null)?
        DateTime.parse(json['studyTime']) : null;

    List<UserProfileSummary> participantProfileSummaries =
      ((json['roundParticipantInfos']??[]) as List).map(
              (p) => UserProfileSummary.fromJson(p)).toList();

    return Round(
      roundId: json['roundId']??nonAllocatedRoundId,
      studyPlace: json['studyPlace']??"",
      studyTime: studyTime,
      detail: json['detail'],
      participantProfileSummaries: participantProfileSummaries,
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

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('create round (studyId: $studyId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      bool success = responseJson['success'];

      if(success) {
        round.roundId = responseJson['data']['roundId'];
        logger.infoLog('created round\'s roundId: ${round.roundId}');
      }
      
      return success;
    }
  }

  static Future<bool> deleteRound(int roundId) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/rounds?roundId=$roundId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('delete round (roundId: $roundId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
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

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('update round\'s appointment (roundId: ${round.roundId})', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<Round> getDetail(int roundId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/rounds/details?roundId=$roundId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('get detail (roundId: $roundId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var roundJson = responseJson['data']['detail'];

      return Round.fromJson(roundJson);
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

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('update detail', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<List<Round>> getRoundList(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/rounds/list?studyId=$studyId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('get round Lists (studyId: $studyId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var roundListJson = responseJson['data']['roundList'];

      List<Round> roundList = (roundListJson as List).map((r) =>
          Round.fromJson(r)).toList();

      return roundList;
    }
  }
}