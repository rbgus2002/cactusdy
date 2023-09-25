
import 'package:group_study_app/models/task.dart';

class TaskGroup {
  final int roundParticipantId;
  final String taskType;
  List<Task> tasks;

  TaskGroup({
    required this.roundParticipantId,
    required this.taskType,
    required this.tasks,
  });

  factory TaskGroup.fromJson(Map<String, dynamic> json) {
    return TaskGroup(
        roundParticipantId: json['roundParticipantId'],
        taskType: json['taskType'],
        tasks: json['tasks']
    );
  }
}