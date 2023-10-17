
import 'package:group_study_app/models/task.dart';

class TaskGroup {
  static final Set<String> sharedTaskGroups = { 'GROUP' };

  final int roundParticipantId;
  final String taskType;
  List<Task> tasks;
  bool isShared;

  TaskGroup({
    required this.roundParticipantId,
    required this.taskType,
    this.tasks = const [],
    required this.isShared,
  });

  factory TaskGroup.fromJson(Map<String, dynamic> json, int roundParticipantId) {
    return TaskGroup(
        roundParticipantId: roundParticipantId,
        taskType: json['taskType'],
        tasks: (json['tasks'] as List).map((t) => Task.fromJson(t)).toList(),
        isShared: (sharedTaskGroups.contains(json['taskType'])),
    );
  }
}