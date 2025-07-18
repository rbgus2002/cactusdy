

import 'dart:convert';
import 'dart:developer' as dev;

import 'package:groupstudy/services/database_service.dart';
import 'package:http/http.dart';

class Logger {
  final String name;

  Logger(this.name);

  void log(String message) {
    dev.log(message, name: name, time: DateTime.now());
  }

  void tryLog(String task) {
    log('TRY: $task');
  }

  void resultLog(String task, Map<String, dynamic> responseJson) {
    bool success = responseJson['success'];
    if (success) {
      successLog(task);
    } else {
      failLog(task, responseJson['message']);
    }
  }

  void resultLogV2(String task, Response response) {
    bool success = (response.statusCode == DatabaseService.successCode);
    if (success) {
      successLog(task);
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      failLog(task, responseJson['message']);
    }
  }

  void failLog(String task, String message) {
    log('FAIL: $task, message: $message');
  }

  void successLog(String task) {
    log('DONE: $task');
  }

  void infoLog(String info) {
    log('INFO: $info');
  }
}
