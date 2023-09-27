
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/models/task_group.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/utilities/test.dart';

class ParticipantInfo {
  final User participant;
  final double taskProgress;
  final List<TaskGroup> taskGroups;

  ParticipantInfo({
    required this.participant,
    required this.taskProgress,
    required this.taskGroups,
  });

  factory ParticipantInfo.fromJson(Map<String, dynamic> json) {
    User participant = User(
        userId: json['userId'],
        nickname: json['nickname'],
        statusMessage: "",
        picture: json['profileImage']);

    return ParticipantInfo(
      participant: participant,
      taskProgress: json['taskProgress'],
      taskGroups: (json['taskGroups'] as List).map((t)
        => TaskGroup.fromJson(t, json['roundParticipantId'])).toList(),
    );
  }
}