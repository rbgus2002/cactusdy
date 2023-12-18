
import 'package:flutter/material.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:intl/intl.dart';

class TimeUtility {
  TimeUtility._();

  static bool isScheduled(DateTime? date) {
    return (date != null && date.compareTo(DateTime.now()) > 0);
  }

  static bool isHeld(DateTime? date) {
    return (date != null && date.compareTo(DateTime.now()) <= 0);
  }

  static String getTime(DateTime dateTime) {
    return DateFormat('a HH:mm',).format(dateTime);
  }

  static String getElapsedTime(BuildContext context, DateTime dateTime) {
    final nowTime = DateTime.now();
    final difference = nowTime.difference(dateTime);

    if (difference.inMinutes < 1) {
      return context.local.justNow;
    }

    else if (difference.inHours < 1) {
      return context.local.beforeOf('${difference.inMinutes}${context.local.min}');
    }

    else if (difference.inDays < 1) {
      return context.local.beforeOf('${difference.inHours}${context.local.hour}');
    }

    else if (nowTime.day - dateTime.day < 2) {
      return context.local.yesterday;
    }

    if (dateTime.year == nowTime.year) {
      return DateFormat('MM.dd').format(dateTime);
    }

    return DateFormat('yyyy.MM.dd').format(dateTime);
  }

  static String timeToString(DateTime dateTime) {
    final nowTime = DateTime.now();

    if (dateTime.year == nowTime.year) {
      return DateFormat('MM/dd(E) a HH:mm',).format(dateTime);
    }

    return DateFormat('yy/MM/dd(E) a HH:mm',).format(dateTime);
  }

  static String secondToString(BuildContext context, int sec) {
    int min = sec ~/ 60;
    sec %= 60;

    if (sec >= 3600) { // 1hour = 60min * 60sec
      int hour = min ~/ 60;
      min %= 60;
      return '$hour${context.local.hour} ${min.toString().padLeft(2, '0')}${context.local.min} ${sec.toString().padLeft(2, '0')}${context.local.sec}';
    }

    else if (min > 0) {
      return '$min${context.local.min} ${sec.toString().padLeft(2, '0')}${context.local.sec}';
    }

    return '$sec${context.local.sec}';
  }

  static Future<DateTime?> showDateTimePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date == null) return null;

    if (context.mounted) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
        initialEntryMode: TimePickerEntryMode.inputOnly,
        cancelText: context.local.cancel,
        confirmText: context.local.confirm,
      );

      if (time == null) return null;

      return DateTime(date.year, date.month, date.day, time.hour, time.minute);
    }
    return null;
  }

  /// For BottomSheets.timePickerBottomSheet
  static DateTime buildDateTime({
    required int aIdx,  // [ am, pm ]
    required int hIdx,  // [ 0(=12):11 ]
    required int mIdx,  // [ 0:55 ] (rotSize = 5)
  }) {
    int hour = (aIdx * 12) + hIdx;
    int min = (mIdx * 5);

    return DateTime(0, 0, 0, hour, min);
  }
}