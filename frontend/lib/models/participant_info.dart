
import 'package:group_study_app/models/status_tag.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/models/task_group.dart';
import 'package:group_study_app/models/user.dart';

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