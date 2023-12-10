
import 'dart:async';

import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/utilities/util.dart';

abstract class StabController {
  static const int _waitingTime = 3; // 3 sec

  final int targetUserId;
  final int studyId;

  StabController({
    required this.targetUserId,
    required this.studyId,
  });

  Timer? _timer;
  int _restTime = 0;
  int _stabCount = 0;

  get stabCount => _stabCount;

  void stab() {
    _restTime = _waitingTime;
    ++_stabCount;

    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      // stop timer
      if (_restTime <= 0) {
        send();
      }
      else {
        --_restTime;
      }
    });
  }

  /// send stab info and call _reset()
  void send();

  /// reset timer and stab count
  void _reset() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
    _stabCount = 0;
  }
}

class UserStabController extends StabController {

  UserStabController({
    required super.targetUserId,
    required super.studyId,
  });

  @override
  void send() async {
    if (_stabCount > 0) {
      try {
        await User.stabUser(
            targetUserId: targetUserId,
            studyId: studyId,
            count: _stabCount);
      } on Exception catch (e) {
        print(Util.getExceptionMessage(e));
      }
    }
    _reset();
  }
}

class TaskStabController extends StabController {
  int taskId;

  TaskStabController({
    required super.targetUserId,
    required super.studyId,
    required this.taskId,
  });

  @override
  void send() async {
    if (_stabCount > 0) {
      try {
        await Task.stabTask(
            targetUserId: targetUserId,
            studyId: studyId,
            taskId: taskId,
            count: _stabCount);
      } on Exception catch (e) {
        print(Util.getExceptionMessage(e));
      }
    }
    _reset();
  }
}