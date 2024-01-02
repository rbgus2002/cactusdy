

import 'dart:convert';

import 'package:groupstudy/services/database_service.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:http/http.dart' as http;

class Rule {
  // string length limit
  static const int ruleMaxLength = 50;

  // state code
  static const int nonAllocatedRuleId = -1;

  // const values
  static const int ruleLimitedCount = 5;

  static Logger logger = Logger('Rule');

  int ruleId;
  String detail;

  Rule({
    this.ruleId = nonAllocatedRuleId,
    this.detail = "",
  });

  factory Rule.fromJson(Map<String, dynamic> json) {
    return Rule(
      ruleId: json['ruleId'],
      detail: json['detail'],
    );
  }

  static Future<List<Rule>> getRules(int studyId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/rules/$studyId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('get rules (studyId: $studyId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var ruleListJson = responseJson['data']['rules'];

      List<Rule> rules = (ruleListJson as List).map((r) =>
          Rule.fromJson(r)).toList();

      return rules;
    }
  }

  static Future<bool> createRule(Rule rule, int studyId) async {
    Map<String, dynamic> data = {
      "studyId": studyId,
      "detail": rule.detail,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/rules'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('create rule', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      bool success = responseJson['success'];

      if(success) {
        rule.ruleId = responseJson['data']['ruleId'];
        logger.infoLog('created rule\'s ruleId: ${rule.ruleId}');
      }

      return success;
    }
  }

  static Future<bool> deleteRule(Rule rule) async {
    if (rule.ruleId == Rule.nonAllocatedRuleId) return false;

    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/rules/${rule.ruleId}'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('delete rule (ruleId: ${rule.ruleId})', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return json.decode(response.body)['success'];
    }
  }

  static Future<bool> updateRuleDetail(Rule rule) async {
    if (rule.ruleId == Rule.nonAllocatedRuleId) return false;

    Map<String, dynamic> data = {
      'detail': rule.detail,
    };

    final response = await http.put(
      Uri.parse('${DatabaseService.serverUrl}api/rules/${rule.ruleId}'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('update rule detail (ruleId: ${rule.ruleId})', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }
}