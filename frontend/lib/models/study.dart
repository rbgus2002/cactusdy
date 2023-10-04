
import 'dart:convert';
import 'dart:ui';

import 'package:group_study_app/services/database_service.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:http/http.dart' as http;

class Study {
  // string length limits
  static const int studyNameMaxLength = 30;
  static const int studyDetailMaxLength = 40;

  final int studyId;
  final String studyName;
  final String detail;
  final String picture;
  final Color color;

  const Study({
    required this.studyId,
    required this.studyName,
    required this.detail,
    required this.picture,
    this.color = ColorStyles.deepPurpleAccent, //< FIXME
  });

  factory Study.fromJson(Map<String, dynamic> json) {
    print(json);
    return Study(
      studyId: json['studyId'],
      studyName: json['studyName'],
      detail: json['detail']??"",
      picture: json['picture'],
    );
  }

  Map<String, dynamic> toJson() => {
    'studyId': studyId,
    'studyName': studyName,
    'detail': detail,
    'picture': picture,
    'color': color,
  };

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
}