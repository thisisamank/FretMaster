import 'dart:async';

import 'package:flutter/material.dart';

class TimerNotifier extends ValueNotifier<int> {
  /// Creates a [TimerNotifier] with the provided [initialTime].
  /// [initialTime] is in milliseconds.
  TimerNotifier(this.totalTime, super.initialTime, this.onComplete);

  Timer? _timer;
  bool _isRunning = false;
  int totalTime;
  final VoidCallback onComplete;
  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;
    value = totalTime;

    _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
      if (value > 0) {
        value -= 10;
      } else {
        stopTimer();
        onComplete();
      }
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _isRunning = false;
  }

  void resetTimer(int newTotalTime) {
    stopTimer();
    totalTime = newTotalTime;
    value = newTotalTime;
    }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
