
import 'package:flutter/material.dart';
import 'package:group_study_app/utilities/extensions.dart';

class StatusTag {
  static Color getColor(String status, BuildContext context) {
    switch (status) {
      case 'NONE':
        return Colors.transparent;

      case 'ATTENDANCE_EXPECTED':
      case 'ATTENDANCE':
        return context.extraColors.green!;

      case 'LATE':
        return context.extraColors.purple!;

      case 'ABSENT':
        return context.extraColors.pink!;

      default:
        // This should be never called
        assert(false, 'Unknown status: $status');
        return Colors.transparent;
    }
  }

  static String getText(String status, BuildContext context) {
    switch (status) {
      case 'NONE':
        return "";

      case 'ATTENDANCE_EXPECTED':
        return context.local.reserved;

      case 'ATTENDANCE':
        return context.local.attend;

      case 'LATE':
        return context.local.late;

      case 'ABSENT':
        return context.local.absent;

      default:
        // This should be never called
        assert(false, 'Unknown status: $status');
        return "";
    }
  }
}