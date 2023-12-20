

import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:http/http.dart' as http;

class Rule {
  static const int ruleMaxLength = 50;
  static const int ruleLimitedCount = 5;
  static const int nonAllocatedRuleId = -1;

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

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to get Rules");
    } else {
      print("Success to get study's rules");
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['rules'];
      return (responseJson as List).map((r) => Rule.fromJson(r)).toList();
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

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to create rule");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      bool success = responseJson['success'];
      if(success) {
        rule.ruleId = responseJson['data']['ruleId'];
        print("New Rule is created successfully");
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

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Fail to delete rule");
    } else {
      bool result = json.decode(response.body)['success'];
      if (result) print("success to delete rule");
      return result;
    }
  }

  static Future<bool> updateTaskDetail(Rule rule) async {
    if (rule.ruleId == Rule.nonAllocatedRuleId) return false;

    Map<String, dynamic> data = {
      'detail': rule.detail,
    };

    final response = await http.put(
      Uri.parse('${DatabaseService.serverUrl}api/rules/${rule.ruleId}'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to update rule detail");
    } else {
      bool success = json.decode(response.body)['success'];
      if (success) print("Success to update rule detail"); //< FIXME
      return success;
    }
  }
}