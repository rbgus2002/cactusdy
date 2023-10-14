
import 'package:group_study_app/services/auth.dart';

class DatabaseService {
  static const serverUrl = 'http://43.200.247.214:8080/';
  static const header = <String, String>{
    'accept': '*/*',
    'Access-Control-Allow-Origin': '*',
    'Content-Type': 'application/json;charset=UTF-8',
  };

  static Map<String, String> getAuthHeader() {
    return {
      'accept': '*/*',
      'Access-Control-Allow-Origin': '*',
      'Content-Type': 'application/json;charset=UTF-8',
      'Authorization': 'Bearer ${Auth.signInfo!.token}'
    };
  }

  static const successCode = 200;
}