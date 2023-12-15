import 'dart:convert';

import 'package:group_study_app/models/study_tag.dart';
import 'package:group_study_app/services/logger.dart';
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

  static Logger logger = Logger('User');

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
        profileImage: json['profileImage']??"",
    );
  }

  static Future<User> getUserProfileSummary() async {
    logger.tryLog('get user profile summary');

    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/users'),
      headers: DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('get user profile summary', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return User.fromJson(responseJson['data']['user']);
    }
  }

  static Future<ParticipantProfile> getUserProfileDetail(int userId, int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies/participants?userId=$userId&studyId=$studyId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception();
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['participant'];
      print('success to get participant profile');
      return ParticipantProfile.fromJson(responseJson);
    }
  }

  static Future<bool> updateUserProfile(User updatedUser, XFile? profileImage) async {
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

  static Future<bool> kickUser({
    required int userId,
    required int studyId,
  }) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/studies/participants/kick?userId=$userId&studyId=$studyId'),
      headers: DatabaseService.getAuthHeader(),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      bool result = json.decode(response.body)['success'];
      if (result) print("success to leave study");
      return result;
    }
  }

  static Future<bool> stabUser({
    required int targetUserId,
    required int studyId,
    required int count}) async {

    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/notifications?targetUserId=$targetUserId&studyId=$studyId&count=$count'),
      headers: DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      if (responseJson['success']) print('success to stab user($count times)');
      return responseJson['success'];
    }
  }
}

class ParticipantProfile {
  final User participant;
  final List<StudyTag> studyTags;
  final Map<String, int> attendanceRate;
  final int doneRate;

  ParticipantProfile({
    required this.participant,
    required this.studyTags,
    required this.attendanceRate,
    required this.doneRate,
  });

  factory ParticipantProfile.fromJson(Map<String, dynamic> json) {
    Map<String, int> attendanceRate = {};
    for (var status in json['statusTagInfoList']) {
      attendanceRate[status['statusTag']] = status['count'];
    }

    return ParticipantProfile(
      participant: User.fromJson(json),
      studyTags: (json['participantInfoList'] as List).map((studyTag) =>
          StudyTag.fromJson(studyTag)).toList(),
      attendanceRate: attendanceRate,
      doneRate: json['doneRate'],
    );
  }
}