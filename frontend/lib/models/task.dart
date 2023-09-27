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

  //< FIXME this is test
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
      Uri.parse('${DatabaseService.serverUrl}tasks?roundId=$roundId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
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
      Uri.parse('${DatabaseService.serverUrl}tasks'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
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


  static Future<bool> updateTaskDetail(Task task, int roundParticipantId) async {
    if (task.taskId == Task.nonAllocatedTaskId) return false;

    Map<String, dynamic> data = {
      'taskId': task.taskId,
      'roundParticipantId': roundParticipantId,
      'detail': task.detail,
    };

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}tasks?taskId=${task.taskId}&roundParticipantId=$roundParticipantId}'),
      headers: DatabaseService.header,
      body: json.encode(data),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to update task detail");
    } else {
      bool success = json.decode(response.body)['success'];
      if(success) print("Success to update task detail"); //< FIXME
      return success;
    }
  }


  /*
  static Future<List<TaskGroup>> getTasks(int roundId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}tasks?roundId=$roundId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to get task list");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['tasks'];

      return (responseJson as List).map((t) => Round.fromJson(r)).toList();
    }


  }
   */


  //< FIXME : this is test module
  static Future<List<Task>> getGroupTasks(int studyId, int roundId, int userId) async {
    List<Task> groupTasks = [];

    groupTasks.add(Task(taskId: nonAllocatedTaskId, detail: "토익 문제 박살내기", isDone: false));
    groupTasks.add(Task(taskId: nonAllocatedTaskId, detail: "TEPS한테 박살나기", isDone: true));

    return groupTasks;
  }

  //< FIXME : this is test module
  static Future<List<Task>> getPersonalTasks(int studyId, int roundId, int userId) async {
    List<Task> personalTasks = [];

    personalTasks.add(Task(taskId: nonAllocatedTaskId, detail: "백준 : 11324", isDone: false));
    personalTasks.add(Task(taskId: nonAllocatedTaskId, detail: "프로그래머스 : 무지의 댄스 타임", isDone: true));

    return personalTasks;
  }


  static Future<bool> switchTask(int taskId, int roundParticipantId) async {
    if (taskId == nonAllocatedTaskId) { return false; }

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}tasks/check?taskId=$taskId&roundParticipantId=$roundParticipantId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception('Failed to switch check task');
    } else {
      String isChecked = json.decode(response.body)['data']['doneYn'];
      return (isChecked == 'Y');
    }
  }
}