import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class User{
  final int userId;
  final String nickname;
  final String statusMessage;
  final String picture;

  User({
    required this.userId,
    required this.nickname,
    required this.statusMessage,
    required this.picture,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        nickname: json['nickname'],
        statusMessage: json['statusMessage'],
        picture: json['picture'],
    );
  }
  static Future<User> getUserProfileSummary(int userId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}users?userId=$userId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Fail to get User Data (userId = $userId)");
    } else {
      print("successfully get User Profile Summary (userId = $userId)");

      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['user'];

      return User.fromJson(responseJson);
    }
  }
}