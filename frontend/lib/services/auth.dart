
import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Auth {
  static const int emailMaxLength = 255;
  static const int passwordMaxLength = 255;

  static Future<int> signIn(String email, String password) async {
    Map<String, dynamic> data = {
      'email': email,
      'password': password,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}auth/signIn'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to sign in");
    } else {
      var responseJson = jsonDecode(response.body)['data']['loginUser'];

      int userId = responseJson['userId'];
      String token = responseJson['token'];

      print("success to sign in");
      return userId;
    }
  }
}