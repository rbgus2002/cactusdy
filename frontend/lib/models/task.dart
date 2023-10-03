import 'dart:convert';

import 'package:group_study_app/models/participant_info.dart';
import 'package:group_study_app/models/task_group.dart';
import 'package:group_study_app/services/database_service.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:http/http.dart' as http;

class Task {
  static const int nonAllocatedTaskId = -1;

  int taskId;
  String detail;
  bool isDone;

  Task({
    this.taskId = nonAllocatedTaskId,
    this.detail = "",
    this.isDone = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      isDone: (json['doneYn'] == 'Y'),
      detail: json['detail'],
    );
  }

  static Future<List<ParticipantInfo>> getTasks(int roundId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/tasks?roundId=$roundId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to get Tasks");
    } else {
      print("Success to get participants Task lists");
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['tasks'];
      return (responseJson as List).map((p) => ParticipantInfo.fromJson(p)).toList();
    }
  }

  static Future<bool> createTask(Task task, String taskType, int roundParticipantId) async {
    Map<String, dynamic> data = {
      "roundParticipantId": roundParticipantId,
      "taskType": taskType,
      "detail": task.detail,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/tasks'),
      headers: DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to create task");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes));
      bool success = responseJson['success'];
      if(success) {
        task.taskId = responseJson['data']['taskId'];
        print("New Task is created successfully");
      }
      return success;
    }
  }

  static Future<bool> deleteTask(int taskId, int roundParticipantId) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/tasks?taskId=$taskId&roundParticipantId=$roundParticipantId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Fail to delete task");
    } else {
      print(response.body);
      bool result = json.decode(response.body)['success'];
      return result;
    }
  }

  static Future<bool> updateTaskDetail(Task task, int roundParticipantId) async {
    if (task.taskId == Task.nonAllocatedTaskId) return false;

    Map<String, dynamic> data = {
      'taskId': task.taskId,
      'roundParticipantId': roundParticipantId,
      'detail': task.detail,
    };

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/tasks?taskId=${task.taskId}&roundParticipantId=$roundParticipantId}'),
      headers: DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception("Failed to update task detail");
    } else {
      bool success = json.decode(response.body)['success'];
      if(success) print("Success to update task detail"); //< FIXME
      return success;
    }
  }

  static Future<bool> switchTask(int taskId, int roundParticipantId) async {
    if (taskId == nonAllocatedTaskId) { return false; }

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/tasks/check?taskId=$taskId&roundParticipantId=$roundParticipantId'),
      headers: DatabaseService.getAuthHeader(),
    );

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception('Failed to switch check task');
    } else {
      String isChecked = json.decode(response.body)['data']['doneYn'];
      return (isChecked == 'Y');
    }
  }
}