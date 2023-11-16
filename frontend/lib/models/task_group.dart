
import 'package:group_study_app/models/task.dart';

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