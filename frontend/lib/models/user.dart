import 'dart:convert';
import 'dart:io';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class User{
  // string length limits
  static const int statusMessageMaxLength = 255;

  // state code
  static const int nonAllocatedUserId = -1;

  final int userId;
  final String nickname;
  String statusMessage;
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

  static Future<User> getUserProfileSummary() async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/users'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Fail to get User Data");
    } else {
      print("successfully get User Profile Summary");

      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['user'];

      return User.fromJson(responseJson);
    }
  }

  static Future<bool> updateStatusMessage(User user) async {
    Map<String, dynamic> data = {
      'statusMessage': user.statusMessage,
    };

    final response = await http.put(
        Uri.parse('${DatabaseService.serverUrl}api/users/profile/messages'),
        headers: DatabaseService.getAuthHeader(),
        body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Fail to update user status message");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      print('${responseJson['message']} to update user status Message');
      return responseJson['success'];
    }
  }

  static Future<bool> updateProfileImage(XFile profileImage) async {
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${DatabaseService.serverUrl}api/users/profile/images'),
    );
    request.headers.addAll(DatabaseService.getAuthHeader());
    request.files.add(await http.MultipartFile.fromPath('profileImage', profileImage.path));

    final response = await request.send();
    final responseJson = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<bool> notifyParticipant(int targetUserId, int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/notifications?targetUserId=$targetUserId&studyId=$studyId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception();
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      if (responseJson['success']) {
        print("success to notify to user_$targetUserId in study_$studyId");
      }

      return responseJson['success'];
    }
  }
}