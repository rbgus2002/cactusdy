
import 'package:flutter/material.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/models/task.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/widgets/participant_info_widget.dart';

class ParticipantInfoListWidget extends StatefulWidget {
  final int roundId;
  final Study study;
  final bool scheduled;

  const ParticipantInfoListWidget({
    Key? key,
    required this.roundId,
    required this.study,
    required this.scheduled,
  }) : super(key: key);

  @override
  State<ParticipantInfoListWidget> createState() => _ParticipantInfoListWidgetState();
}

class _ParticipantInfoListWidgetState extends State<ParticipantInfoListWidget> {
  final Map<String, Map<int, Function(Task)>> listeners = { };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Task.getTasks(widget.roundId),
      builder: (context, snapshot) =>
        (snapshot.hasData) ?
          ListView.builder(
            shrinkWrap: true,
            primary: false,

            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: context.extraColors.grey100!,
                        width: 1,),),),
                  child: ParticipantInfoWidget(
                    participantInfo: snapshot.data![index],
                    roundId: widget.roundId,
                    subscribe: _addListener,
                    notify: _notify,
                    study: widget.study,
                    scheduled: widget.scheduled,)
              );
            },
          ) : Design.loadingIndicator,
    );
  }

  void _addListener(String taskType, int key, Function(Task) addTask) {
    if (!listeners.containsKey(taskType)) {
      listeners[taskType] = { };
    }

    listeners[taskType]![key] = addTask;
  }

  void _notify(String taskType, int notifierId, String detail, List<TaskInfo> newTaskInfoList) {
    if (listeners.containsKey(taskType)) {
      for (var newTaskInfo in newTaskInfoList) {
        // exclude it's self
        if (newTaskInfo.roundParticipantId != notifierId) {
          if (listeners[taskType]!.containsKey(newTaskInfo.roundParticipantId)) {
            listeners[taskType]![newTaskInfo.roundParticipantId]!(
              Task(taskId: newTaskInfo.taskId, detail: detail, isDone: false,),);
          }
        }
      }
    }
  }
}
