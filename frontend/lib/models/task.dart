import 'dart:convert';

import 'package:groupstudy/models/status_tag.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/services/database_service.dart';
import 'package:groupstudy/services/logger.dart';
import 'package:http/http.dart' as http;

class Task {
  // string length limit
  static const int taskMaxLength = 255;

  // state code
  static const int nonAllocatedTaskId = -1;

  static Logger logger = Logger('Task');

  int taskId;
  String detail;
  bool isDone;

  Task({
    this.taskId = nonAllocatedTaskId,
    this.detail = "",
    this.isDone = false,
  });

  @override
  String toString() {
    return '$detail $isDone';
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      taskId: json['taskId'],
      isDone: (json['doneYn'] == 'Y'),
      detail: json['detail']??"",
    );
  }

  // ParticipantInfo include tasks
  static Future<List<ParticipantInfo>> getParticipantInfoList(int roundId) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/tasks?roundId=$roundId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('get tasks (roundId: $roundId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var participantInfoListJson = responseJson['data']['tasks'];

      List<ParticipantInfo> participantInfoList = (participantInfoListJson as List).map((p) => ParticipantInfo.fromJson(p)).toList();
      return participantInfoList;
    }
  }

  static Future<bool> createPersonalTask({
      required Task task,
      required int roundParticipantId}) async {
    Map<String, dynamic> data = {
      "roundParticipantId": roundParticipantId,
      "detail": task.detail,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/tasks/personal'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('create personal task', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      bool success = responseJson['success'];
      if(success) {
        task.taskId = responseJson['data']['taskId'];
        logger.infoLog('created task\'s taskId: ${task.taskId}');
      }
      return success;
    }
  }

  static Future<bool> createGroupTask({
      required Task task,
      required int roundId,
      required int roundParticipantId,
      required Function(String, List<TaskInfo>)? notify}) async {
    Map<String, dynamic> data = {
      "roundId": roundId,
      "detail": task.detail,
    };

    final response = await http.post(
      Uri.parse('${DatabaseService.serverUrl}api/tasks/group'),
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('create group task', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      var taskInfoListJson = responseJson['data']['groupTasks'];

      List<TaskInfo> taskInfoList = ((taskInfoListJson??[]) as List).map((i) =>
          TaskInfo.fromJson(i)).toList();

      // find adder's taskId
      for (var taskInfo in taskInfoList) {
        if (taskInfo.roundParticipantId == roundParticipantId) {
          task.taskId = taskInfo.taskId;
          break;
        }
      }

      // if there are other's taskGroup => notify
      if (notify != null) {
        notify(task.detail, taskInfoList);
      }

      return responseJson['success'];
    }
  }

  static Future<bool> deleteTask(int taskId, int roundParticipantId) async {
    final response = await http.delete(
      Uri.parse('${DatabaseService.serverUrl}api/tasks?taskId=$taskId&roundParticipantId=$roundParticipantId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('delete task (taskId: $taskId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
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
      headers: await DatabaseService.getAuthHeader(),
      body: json.encode(data),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('update task detail (taskId: ${task.taskId}, detail: ${task.detail})', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }

  static Future<bool> switchTask(int taskId) async {
    if (taskId == nonAllocatedTaskId) { return false; }

    final response = await http.patch(
      Uri.parse('${DatabaseService.serverUrl}api/tasks/check?taskId=$taskId'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('switch task (taskId: $taskId)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      String isChecked = responseJson['data']['doneYn'];
      logger.infoLog('switch task\'s check as $isChecked');

      return (isChecked == 'Y');
    }
  }

  static Future<bool> stabTask({
      required int targetUserId,
      required int studyId,
      required int roundId,
      required int taskId,
      required int count}) async {
    final response = await http.get(
      Uri.parse('${DatabaseService.serverUrl}api/notifications/tasks?targetUserId=$targetUserId&studyId=$studyId&roundId=$roundId&taskId=$taskId&count=$count'),
      headers: await DatabaseService.getAuthHeader(),
    );

    var responseJson = json.decode(utf8.decode(response.bodyBytes));
    logger.resultLog('stab task (taskId: $taskId, count: $count)', responseJson);

    if (response.statusCode != DatabaseService.successCode) {
      throw Exception(responseJson['message']);
    } else {
      return responseJson['success'];
    }
  }
}

class TaskInfo {
  final int roundParticipantId;
  final int taskId;

  TaskInfo({
    required this.roundParticipantId,
    required this.taskId,
  });

  factory TaskInfo.fromJson(Map<String, dynamic> json) {
    return TaskInfo(
      roundParticipantId: json['roundParticipantId'],
      taskId: json['taskId'],
    );
  }
}

class TaskGroup {
  static final Set<String> sharedTaskGroups = { 'GROUP' };

  final int roundParticipantId;
  final String taskType;
  final String taskTypeName;
  final List<Task> tasks;
  bool isShared;

  TaskGroup({
    required this.roundParticipantId,
    required this.taskType,
    required this.taskTypeName,
    this.tasks = const [],
    required this.isShared,
  });

  factory TaskGroup.fromJson(Map<String, dynamic> json, int roundParticipantId) {
    return TaskGroup(
      roundParticipantId: roundParticipantId,
      taskType: json['taskType'],
      taskTypeName: json['taskTypeName'],
      tasks: (json['tasks'] as List).map((t) => Task.fromJson(t)).toList(),
      isShared: (sharedTaskGroups.contains(json['taskType'])),
    );
  }
}

class ParticipantInfo {
  final int roundParticipantId;
  final User participant;
  final StatusTag status;
  final List<TaskGroup> taskGroups;

  ParticipantInfo({
    required this.roundParticipantId,
    required this.participant,
    required this.status,
    required this.taskGroups,
  });

  factory ParticipantInfo.fromJson(Map<String, dynamic> json) {
    return ParticipantInfo(
      roundParticipantId: json['roundParticipantId'],
      participant: User.fromJson(json),
      status: StatusTag.getByCode(json['statusTag']),
      taskGroups: (json['taskGroups'] as List).map((t)
      => TaskGroup.fromJson(t, json['roundParticipantId'])).toList(),
    );
  }

  double getTaskProgress() {
    int taskCount = 0;
    int doneCount = 0;

    for (TaskGroup taskGroup in taskGroups) {
      taskCount += taskGroup.tasks.length;
      for (Task task in taskGroup.tasks) {
        if (task.isDone) ++doneCount;
      }
    }

    if (taskCount == 0) return 0;

    return (doneCount / taskCount);
  }
}