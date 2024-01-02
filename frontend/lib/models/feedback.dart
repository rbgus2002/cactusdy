

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:groupstudy/services/database_service.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:http/http.dart' as http;

enum AppFeedback {
  bug(bugCode),
  feat(featCode),
  enhance(enhanceCode),
  etc(etcCode);

  // string length limits
  static const int titleMaxLength = 50;
  static const int contentsMaxLength = 255;

  // state code
  static const String bugCode = 'BUG';
  static const String featCode = 'FEAT';
  static const String enhanceCode = 'ENHANCE';
  static const String etcCode = 'ETC';

  static Logger logger = Logger('Feedback');

  final String code;
  const AppFeedback(this.code);

  factory AppFeedback.getByCode(String code) {
    return AppFeedback.values.firstWhere((value) => value.code == code);
  }

  String text(BuildContext context) {
    switch (this) {
      case AppFeedback.bug:
        return context.local.bug;

      case AppFeedback.feat:
        return context.local.feat;

      case AppFeedback.enhance:
        return context.local.enhance;

      case AppFeedback.etc:
        return context.local.etc;

      default:
        // This should be never called
        assert(false, 'Unknown status: $code');
        return "";
    }
  }

  IconData icon() {
    switch (this) {
      case AppFeedback.bug:
        return Icons.bug_report_outlined;

      case AppFeedback.feat:
        return Icons.lightbulb_outline;

      case AppFeedback.enhance:
        return Icons.add_chart_outlined;

      case AppFeedback.etc:
        return Icons.more_horiz_outlined;

      default:
        // This should be never called
        assert(false, 'Unknown status: $code');
        return Icons.bug_report_outlined;
    }
  }

  static Future<bool> sendFeedback(AppFeedback type, String title, String contents) async {
    Map<String, dynamic> data = {
      'title': title,
      'contents': contents,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/feedbacks/${type.code}'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('send feedback', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }
}