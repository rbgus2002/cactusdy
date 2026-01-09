class AsyncLock {
  bool _isProcessing = false;
  bool get isProcessing => _isProcessing;

  DateTime? _lastExecutionTime;

  Future<void> callOnlyOnce<T>(
      {required Future<T> Function() action,
      Duration duration = const Duration(seconds: 1)}) async {
    if (_isProcessing) return;
    if (_lastExecutionTime != null &&
        DateTime.now().difference(_lastExecutionTime!) < duration) {
      return;
    }

    _isProcessing = true;
    _lastExecutionTime = DateTime.now();
    try {
      await action();
    } finally {
      _isProcessing = false;
    }
  }

  void release() {
    _isProcessing = false;
  }
}
