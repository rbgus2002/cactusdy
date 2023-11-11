
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/models/task_group.dart';
import 'package:group_study_app/models/user.dart';

class ParticipantInfo {
  final User participant;
  final List<TaskGroup> taskGroups;

  ParticipantInfo({
    required this.participant,
    required this.taskGroups,
  });

  factory ParticipantInfo.fromJson(Map<String, dynamic> json) {
    User participant = User(
        userId: json['userId'],
        nickname: json['nickname'],
        statusMessage: "",
        picture: json['profileImage']??"");

    return ParticipantInfo(
      participant: participant,
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

    if (taskCount == 0) return 1;

    return (doneCount / taskCount);
  }
}