

import 'dart:developer' as dev;

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

  void failLog(String task, String message) {
    log('FAIL: $task, message: $message');
  }

  void successLog(String message) {
    log('SUCCESS: success to $message');
  }
}