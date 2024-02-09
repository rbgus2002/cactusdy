
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:groupstudy/services/flavor.dart';

class SignInfo {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static late final String _signInfoKey;
  static const String _signInfoDevKey = 'signInfoDev';
  static const String _signInfoProdKey = 'signInfo';

  final int userId;
  final String token;
  final String fcmToken;

  SignInfo({
    required this.userId,
    required this.token,
    required this.fcmToken,
  });

  /// For Flavor
  static void init(FlavorType flavor) {
    switch (flavor) {
      case FlavorType.dev:
        _signInfoKey = _signInfoDevKey;
        break;

      case FlavorType.prod:
        _signInfoKey = _signInfoProdKey;
        break;
    }
  }

  @override
  String toString() {
    return "{ userId : $userId, token : $token, fcmToken : $fcmToken }";
  }

  factory SignInfo.fromJson(Map<String, dynamic> json) {
    return SignInfo(
        userId: json['userId'],
        token: json['token'],
        fcmToken: json['fcmToken'],
    );
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {
      'userId': userId,
      'token': token,
      'fcmToken': fcmToken,
    };

    return data;
  }

  static Future<SignInfo?> readSignInfo() async {
    String? signInfoJson = await _storage.read(key: _signInfoKey);

    if (signInfoJson != null) {
      SignInfo signInfo = SignInfo.fromJson(json.decode(signInfoJson));
      return signInfo;
    }

    return null;
  }

  static Future<void> setSignInfo(SignInfo signInfo) async {
    await _storage.write(
        key: _signInfoKey, value: json.encode(signInfo.toMap()));
  }

  static Future<void> removeSignInfo() async {
    await _storage.delete(key: _signInfoKey);
  }
}