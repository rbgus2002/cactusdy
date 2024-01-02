import 'dart:convert';

import 'package:groupstudy/models/study_tag.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:groupstudy/services/database_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class User{
  // string length limits
  static const int nameMaxLength = 255;
  static const int nicknameMaxLength = 6;
  static const int statusMessageMaxLength = 20;

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
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('get user profile summary', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      if (response.statusCode == DatabaseService.unauthorizedCode) {
        throw Exception("unauthorized");
      }
      throw Exception(responseJson['message']);
    } else {
      return User.fromJson(responseJson['data']['user']);
    }
  }

  static Future<UserProfile> getUserProfileDetail(int userId, int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/studies/participants?userId=$userId&studyId=$studyId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception();
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['participant'];
      print('success to get participant profile');
      return UserProfile.fromJson(responseJson);
    }
  }

  static Future<bool> updateUserProfile(User updatedUser, XFile? profileImage) async {
    final request = http.MultipartRequest('PATCH',
      Uri.parse('${DatabaseService.serverUrl}api/users'),);

    request.headers.addAll(await DatabaseService.getAuthHeader());

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
      updatedUser.profileImage = responseJson['data']['user']['profileImage']??"";

      return responseJson['success'];
    }
  }

  static Future<bool> kickUser({
    required int userId,
    required int studyId,
  }) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/studies/participants/kick?userId=$userId&studyId=$studyId'),
      headers: await DatabaseService.getAuthHeader(),
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
      headers: await DatabaseService.getAuthHeader(),
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

class UserProfile {
  final User user;
  final List<StudyTag> studyTags;
  final Map<String, int> attendanceRate;
  final int doneRate;
  final bool isParticipated;

  UserProfile({
    required this.user,
    required this.studyTags,
    required this.attendanceRate,
    required this.doneRate,
    required this.isParticipated,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    Map<String, int> attendanceRate = {};
    for (var status in json['statusTagInfoList']) {
      attendanceRate[status['statusTag']] = status['count'];
    }

    return UserProfile(
      user: User.fromJson(json),
      studyTags: (json['participantInfoList'] as List).map((studyTag) =>
          StudyTag.fromJson(studyTag)).toList(),
      attendanceRate: attendanceRate,
      doneRate: json['doneRate'],
      isParticipated: (json['isParticipated'] == 'Y'),
    );
  }
}

class UserProfileSummary {
  final int userId;
  final String picture;
  final String nickname;

  UserProfileSummary({
    required this.userId,
    required this.picture,
    required this.nickname,
  });

  factory UserProfileSummary.fromJson(Map<String, dynamic> json) {
    return UserProfileSummary(
      userId: json['userId']??User.nonAllocatedUserId,
      picture: json['picture']??"",
      nickname: json['nickname']??"",
    );
  }
}