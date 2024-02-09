
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:groupstudy/models/sign_info.dart';
import 'package:groupstudy/services/database_service.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';

class Auth {
  Auth._();

  // string length limits
  static const int phoneNumberMaxLength = 255;
  static const int passwordMaxLength = 255;

  // const values
  static const int verificationCodeLength = 6;
  static const int expireTime = 60 * 3; // Verification Code Expire Time : 3 min

  static Logger logger = Logger('Auth');
  static SignInfo? signInfo;

  static Future<bool> signUp({
      required String name,
      required String nickname,
      required String phoneNumber,
      required String password,
      XFile? profileImage,
    }) async {

    final request = http.MultipartRequest('Post',
        Uri.parse('${DatabaseService.serverUrl}auth/signUp'),);

    request.headers.addAll(DatabaseService.header);

    Map<String, dynamic> data = {
      'name': name,
      'nickname': nickname,
      'phoneNumber': phoneNumber,
      'password': password,
    };

    request.files.add(http.MultipartFile.fromString(
      'dto', jsonEncode(data), contentType: MediaType("application","json"),));

    if (profileImage != null) {
      request.files.add(await http.MultipartFile.fromPath('profileImage', profileImage.path));
    }

    final response = await request.send();
    final responseJson = jsonDecode(await response.stream.bytesToString());
    logger.resultLog('sign up', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<bool> signIn(String phoneNumber, String password, String fcmToken) async {
    Map<String, dynamic> data = {
      'phoneNumber': phoneNumber,
      'password': password,
      'fcmToken': fcmToken,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}auth/signIn'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    logger.resultLog('sign in', responseJson);
    
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      //< FIXME
      var signInfoJson = responseJson['data']['loginUser'];
      signInfoJson['fcmToken'] = fcmToken;

      signInfo = SignInfo.fromJson(responseJson['data']['loginUser']);
      SignInfo.setSignInfo(signInfo!);

      logger.infoLog('user auth token: ${signInfo!.token}');

      return responseJson['success'];
    }
  }

  static Future<void> signOut() async {
    await SignInfo.removeSignInfo();
    signInfo = null;
  }

  static Future<bool> removeFCMToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    if (token == null) {
      return true;
    }

    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/notifications/tokens?token=$token'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    logger.resultLog('remove fcm token', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      logger.infoLog('firebase messaging token is removed: $token');
      return responseJson['success'];
    }
  }

  static Future<void> loadSignInfo() async {
    signInfo ??= await SignInfo.readSignInfo();
    logger.infoLog('user token: ${signInfo?.token??'null'}');
  }

  static Future<bool> requestSingUpVerifyMessage(String phoneNumber) async {
    Map<String, dynamic> data = {
      'phoneNumber': phoneNumber,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}auth/signUp/send'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    logger.resultLog('request signup verify message (phoneNumber: $phoneNumber)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<bool> requestResetPasswordVerifyMessage(String phoneNumber) async {
    Map<String, dynamic> data = {
      'phoneNumber': phoneNumber,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}auth/passwords/send'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    logger.resultLog('request reset password verify message (phoneNumber: $phoneNumber)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<bool> verifyCode(String phoneNumber, String code) async {
    Map<String, dynamic> data = {
      'phoneNumber': phoneNumber,
      'code': code,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}auth/verify'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    logger.resultLog('verify code (code: $code)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['data']['isSuccess'];
    }
  }

  static Future<bool> resetPassword(String phoneNumber, String newPassword) async {
    Map<String, dynamic> data = {
      'phoneNumber': phoneNumber,
      'newPassword': newPassword
    };

    final response = await http.put(
      Uri.parse('${DatabaseService.serverUrl}auth/passwords'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    logger.resultLog('resetPassword (phoneNumber: $phoneNumber)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }
}