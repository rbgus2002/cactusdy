
import 'dart:convert';

import 'package:group_study_app/models/sign_info.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Auth {
  static const int emailMaxLength = 255;
  static const int passwordMaxLength = 255;

  static SignInfo? signInfo;

  static Future<bool> signIn(String email, String password) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
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
}