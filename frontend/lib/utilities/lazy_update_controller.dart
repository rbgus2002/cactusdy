

import 'dart:async';
import 'dart:ui';

import 'package:groupstudy/services/logger.dart';

@Deprecated("This feature should be moved to BackEnd")
class LazyUpdateController<T> {
  static Logger logger = Logger('lazyUpdateController');

  final VoidCallback onUpdate;
  late T _lastState;
  late T _currentState;

  Timer? _timer;
  int _restTime = 0;

  LazyUpdateController({
    required T initState,
    required this.onUpdate,
  }) {
    _lastState = initState;
    _currentState = initState;
  }

  void lazyUpdate(T newState, int waitingTime) {
    _restTime = waitingTime;
    _currentState = newState;

    _timer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      // stop timer
      if (_restTime <= 0) {
        update();
      }
      else {
        --_restTime;
      }
    });
  }

  void update() {
    if (_lastState != _currentState) {
      _lastState = _currentState;
      onUpdate();
    }

    _reset();
  }

  /// reset timer and stab count
  void _reset() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }
}
