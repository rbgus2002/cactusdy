
import 'package:flutter/material.dart';
import 'package:group_study_app/utilities/extensions.dart';

class StatusTag {
  static const String none = 'NONE';
  static const String attendanceExcepted = 'ATTENDANCE_EXPECTED';
  static const String attendance = 'ATTENDANCE';
  static const String late = 'LATE';
  static const String absent = 'ABSENT';

  static Color getColor(String status, BuildContext context) {
    switch (status) {
      case none:
        return Colors.transparent;

      case attendanceExcepted:
      case attendance:
        return context.extraColors.green!;

      case late:
        return context.extraColors.purple!;

      case absent:
        return context.extraColors.pink!;

      default:
        // This should be never called
        assert(false, 'Unknown status: $status');
        return Colors.transparent;
    }
  }

  static String getText(String status, BuildContext context) {
    switch (status) {
      case none:
        return "";

      case attendanceExcepted:
        return context.local.reserved;

      case attendance:
        return context.local.attend;

      case late:
        return context.local.late;

      case absent:
        return context.local.absent;

      default:
        // This should be never called
        assert(false, 'Unknown status: $status');
        return "";
    }
  }
}