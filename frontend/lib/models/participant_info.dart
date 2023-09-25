
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/models/task_group.dart';
import 'package:group_study_app/models/user.dart';

class ParticipantInfo {
  final User participant;
  final double taskProgress;
  final TaskGroup groupTasks;
  final TaskGroup personalTasks;

  ParticipantInfo({
    required this.participant,
    required this.taskProgress,
    required this.groupTasks,
    required this.personalTasks,
  });

  factory ParticipantInfo.fromJson(Map<String, dynamic> json) {
    User participant = User(
        userId: json['userId'],
        nickname: json['nickName'],
        statusMessage: "",
        picture: "");

    double taskProgress = json['taskProgress'];

    TaskGroup groupTasks = TaskGroup(
      roundParticipantId: json['roundParticipantId'],
      taskType: "GROUP",
      tasks: (json['groupTasks'] as List).map((t) => Task.fromJson(t)).toList(),
    );

    TaskGroup personalTasks = TaskGroup(
      roundParticipantId: json['roundParticipantId'],
      taskType: "PERSONAL",
      tasks: (json['personalTasks'] as List).map((t) => Task.fromJson(t)).toList(),
    );

    print(personalTasks.taskType);
    print(personalTasks.tasks);
    print(personalTasks);

    return ParticipantInfo(
      participant: participant,
      taskProgress: taskProgress,
      groupTasks: groupTasks,
      personalTasks: personalTasks,
    );
  }
}