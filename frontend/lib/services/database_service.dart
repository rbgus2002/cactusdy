
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/services/flavor.dart';

class DatabaseService {
  DatabaseService._();

  static late final String serverUrl;
  static const String _serverUrlProd = 'https://cactusdy.guegue.dev/';
  static const String _serverUrlDev = 'https://cactusdy.guegue.dev/';

  /// For Flavor
  static void init(FlavorType flavor) {
    switch (flavor) {
      case FlavorType.dev:
        serverUrl = _serverUrlDev;
        break;

      case FlavorType.prod:
        serverUrl = _serverUrlProd;
        break;
    }
  }

  static const header = <String, String>{
    'accept': '*/*',
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json;charset=UTF-8',
  };

  static Future<Map<String, String>> getAuthHeader() async {
    if (Auth.signInfo == null) {
      await Auth.loadSignInfo();
    }

    return {
      'accept': '*/*',
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': 'Bearer ${Auth.signInfo?.token}'
    };
  }

  static const successCode = 200;
  static const unauthorizedCode = 401;
}