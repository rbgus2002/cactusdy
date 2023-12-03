import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class User{
  // string length limits
  static const int nameMaxLength = 255;
  static const int nicknameMaxLength = 255;
  static const int statusMessageMaxLength = 255;

  // state code
  static const int nonAllocatedUserId = -1;

  final int userId;
  String nickname;
  String statusMessage;
  String profileImage;

  User({
    required this.userId,
    required this.nickname,
    required this.statusMessage,
    required this.profileImage,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        userId: json['userId'],
        nickname: json['nickname']??"",
        statusMessage: json['statusMessage']??"",
        profileImage: json['profileImage']??"", //< FIXME : null handling
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

  static Future<bool> updateUser(User updatedUser, XFile? profileImage) async {
    final request = http.MultipartRequest('PATCH',
      Uri.parse('${DatabaseService.serverUrl}api/users'),);

    request.headers.addAll(DatabaseService.getAuthHeader());

    Map<String, dynamic> data = {
      'nickname': updatedUser.nickname,
      'statusMessage': updatedUser.statusMessage,
    };

    request.files.add(http.MultipartFile.fromString(
      'dto', jsonEncode(data), contentType: MediaType("application","json"),));

    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profileImage', profileImage.path));
    }

    final response = await request.send();
    final responseJson = jsonDecode(await response.stream.bytesToString());

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      print('sucess to update user profile');
      updatedUser.profileImage = responseJson['data']['user']['profileImage'];

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