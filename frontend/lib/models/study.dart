
import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Study {
  // string length limits
  static const int studyNameMaxLength = 30;
  static const int studyDetailMaxLength = 40;

  final int studyId;
  final String studyName;
  final String detail;
  final String picture;

  const Study({
    required this.studyId,
    required this.studyName,
    required this.detail,
    required this.picture,
  });

  factory Study.fromJson(Map<String, dynamic> json) {
    return Study(
      studyId: json['studyId'],
      studyName: json['studyName'],
      detail: json['detail'],
      picture: json['picture']
    );
  }

  Map<String, dynamic> toJson() => {
    'studyId': studyId,
    'studyName': studyName,
    'detail': detail,
    'picture': picture
  };

  static Future<Study> getStudySummary(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}studies?studyId=$studyId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to get Study Summary");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['studySummary'];
      return Study.fromJson(responseJson);
    }
  }
}