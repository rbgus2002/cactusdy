
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SignInfo {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();
  static const String _signInfoKey = 'signInfo';

  final int userId;
  final String token;

  SignInfo({
    required this.userId,
    required this.token,
  });

  @override
  String toString() {
    return "{ $userId, $token }";
  }

  factory SignInfo.fromJson(Map<String, dynamic> json) {
    return SignInfo(
        userId: json['userId'],
        token: json['token']
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'userId': userId,
      'token': token,
    };

    return data;
  }

  static Future<SignInfo?> tryGetSignInInfo() async {
    String? signInfoJson = await _storage.read(key: _signInfoKey);

    if (signInfoJson != null) {
      SignInfo signInfo = SignInfo.fromJson(json.decode(signInfoJson));
      return signInfo;
    }

    return null;
  }

  static void setSignInfo(SignInfo signInfo) async {
    await _storage.write(
        key: _signInfoKey, value: json.encode(signInfo.toMap()));
  }

  static void removeSignInfo() {
    _storage.delete(key: _signInfoKey);
  }
}