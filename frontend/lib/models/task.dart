import 'dart:convert';

import 'package:group_study_app/services/database_service.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:http/http.dart' as http;

class Task {
  static const int nonAllocatedTaskId = -1;

  int taskId;
  int userId;
  String text;
  bool isDone;

  Task({
    this.userId = -1,
    this.taskId = nonAllocatedTaskId,
    this.text = "",
    this.isDone = false,
  });


  /*
  static Future<List<Round>> getTasks(int roundId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}tasks?roundId=$roundId'),
    );

    if (response.statusCode != DatabaseService.SUCCESS_CODE) {
      throw Exception("Failed to get RoundInfos");
    } else {
      var responseJson = json.decode(utf8.decode(response.bodyBytes))['data']['roundList'];

      return (responseJson as List).map((r) => Round.fromJson(r)).toList();
    }
  }
   */


  //< FIXME : this is test module
  static Future<List<Task>> getGroupTasks(int studyId, int roundId, int userId) async {
    List<Task> groupTasks = [];

    groupTasks.add(Task(taskId: nonAllocatedTaskId, text: "토익 문제 박살내기", isDone: false));
    groupTasks.add(Task(taskId: nonAllocatedTaskId, text: "TEPS한테 박살나기", isDone: true));

    return groupTasks;
  }

  //< FIXME : this is test module
  static Future<List<Task>> getPersonalTasks(int studyId, int roundId, int userId) async {
    List<Task> personalTasks = [];

    personalTasks.add(Task(taskId: nonAllocatedTaskId, text: "백준 : 11324", isDone: false));
    personalTasks.add(Task(taskId: nonAllocatedTaskId, text: "프로그래머스 : 무지의 댄스 타임", isDone: true));

    return personalTasks;
  }

  //< FIXME : this is test module
  static Future<bool> switchIsDone(int taskId, bool current) async {
    if (taskId == nonAllocatedTaskId) { return false; }

    return !current;
  }
}