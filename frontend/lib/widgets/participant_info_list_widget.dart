
import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/participant_info_widget.dart';

class ParticipantInfoListWidget extends StatefulWidget {
  final int roundId;
  final Study study;

  const ParticipantInfoListWidget({
    Key? key,
    required this.roundId,
    required this.study,
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
          List participantInfoList = snapshot.data!;
          return ListView.builder(
            shrinkWrap: true,
            primary: false,

            itemCount: participantInfoList.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                        horizontal: BorderSide(
                          color: context.extraColors.grey100!,
                          width: 1,),),),
                  child: ParticipantInfoWidget(
                    participantInfo: participantInfoList[index],
                    subscribe: addListener,
                    notify: notify,
                    study: widget.study,)
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
