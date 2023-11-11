
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:group_study_app/models/sign_info.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Auth {
  static const int phoneNumberMaxLength = 255;
  static const int passwordMaxLength = 255;

  static SignInfo? signInfo;

  static Future<bool> signUp({
      required String name,
      required String nickname,
      required String phoneModel,
      required String picture,
      required String phoneNumber,
      required String password,
    }) async {
    return true;
    Map<String, dynamic> data = {
      'name': name,
      'nickname': nickname,
      'phoneModel': phoneModel,
      'picture': picture,
      'phoneNumber': phoneNumber,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}auth/signUp'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      bool result = responseJson['success'];
      if (result) print("success to sign up");
      return result;
    }
  }

  static Future<bool> signIn(String phoneNumber, String password) async {
    Map<String, dynamic> data = {
      'phoneNumber': phoneNumber,
      'password': password,
      'fcmToken': await FirebaseMessaging.instance.getToken(),
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}auth/signIn'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      signInfo = SignInfo.fromJson(responseJson['data']['loginUser']);
      print('User Auth Token : ${signInfo!.token}');
      SignInfo.setSignInfo(signInfo!);
      print("success to sign in");

      return true;
    }
  }

  static void signOut() {
    SignInfo.removeSignInfo();
    signInfo = null;
  }

  static void getSignInfo() async {
    signInfo ??= await SignInfo.readSignInfo();
  }

  static Future<bool> requestSingUpVerifyMessage(String phoneNumber) async {
    return true;
    Map<String, dynamic> data = {
      'phoneNumber': phoneNumber,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}auth/signUp/send'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<bool> requestResetPasswordVerifyMessage(String phoneNumber) async {
    return true;
    Map<String, dynamic> data = {
      'phoneNumber': phoneNumber,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}auth/passwords/send'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    var responseJson = jsonDecode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<bool> verifyCode(String phoneNumber, String code) async {
    return true;
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
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      if (responseJson['data']['isSuccess']) {
        print("verified the code");
      }
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
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      print("success to reset password");
      return responseJson['success'];
    }
  }
}