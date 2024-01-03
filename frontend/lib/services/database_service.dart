
import 'package:groupstudy/services/auth.dart';

class DatabaseService {
  DatabaseService._();

  static late final String serverUrl;
  static const String _serverUrlProd = 'http://3.39.16.245:8080/';
  static const String _serverUrlDev = 'http://43.200.247.214:8080/';

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