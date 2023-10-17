
import 'package:flutter/material.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/widgets/participant_info_widget.dart';
import 'package:group_study_app/widgets/tasks/task_group_widget.dart';

class ParticipantInfoListWidget extends StatefulWidget {
  final int roundId;

  const ParticipantInfoListWidget({
    Key? key,
    required this.roundId,
  }) : super(key: key);

  @override
  State<ParticipantInfoListWidget> createState() => _ParticipantInfoListWidgetState();
}

class _Callback {
  int key;
  Function(Task) addTask;

  _Callback(this.key, this.addTask);
}

class _ParticipantInfoListWidgetState extends State<ParticipantInfoListWidget> {
  final Map<String, List<_Callback>> listeners = { };

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Task.getTasks(widget.roundId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List participantInfos = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            primary: false,

            itemCount: participantInfos.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: Design.bottom10,
                  child: ParticipantInfoWidget(
                    participantInfo: participantInfos[index],
                    subscribe: addListener,
                    notify: notify,
                  )
              );
            },);
        }

        return Design.loadingIndicator;
      },
    );
  }

  void addListener(String taskType, int key, Function(Task) addTask) {
    if (!listeners.containsKey(taskType)) {
      listeners[taskType] = [];
    }

    listeners[taskType]!.add(_Callback(key, addTask));
  }

  void notify(String taskType, int notifierKey, Task newTask) {
    if (listeners[taskType] != null) {
      for (var callback in listeners[taskType]!) {
        // exclude self
        if (callback.key != notifierKey) {
          callback.addTask(newTask);
        }
      }
    }
  }
}
