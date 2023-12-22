
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groupstudy/services/database_service.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:http/http.dart' as http;

enum StatusTag {
  attendance(attendanceCode),
  late(lateCode),
  absent(absentCode);

  static const String attendanceCode = 'ATTENDANCE';
  static const String lateCode = 'LATE';
  static const String absentCode = 'ABSENT';

  final String code;
  const StatusTag(this.code);

  factory StatusTag.getByCode(String code) {
    return StatusTag.values.firstWhere((value) => value.code == code);
  }

  Color color(BuildContext context) {
    switch (this) {
      case StatusTag.attendance:
        return context.extraColors.green!;

      case StatusTag.late:
        return context.extraColors.purple!;

      case StatusTag.absent:
        return context.extraColors.pink!;

      default:
        // This should be never called
        assert(false, 'Unknown status: $code');
        return Colors.transparent;
    }
  }

  String text(BuildContext context, bool reserved) {
    switch (this) {
      case StatusTag.attendance:
        return (reserved) ?
        context.local.reserved :
        context.local.attend;

      case StatusTag.late:
        return context.local.late;

      case StatusTag.absent:
        return context.local.absent;

      default:
        // This should be never called
        assert(false, 'Unknown status: $code');
        return "";
    }
  }

  static Future<bool> updateStatus(int roundParticipateId, StatusTag status) async {
    final response = await http.put(
      Uri.parse('${DatabaseService.serverUrl}api/rounds/participants/$roundParticipateId?statusTag=${status.code}'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      bool result = responseJson['success'];
      if (result) print("Success to update Status");
      return result;
    }
  }
}