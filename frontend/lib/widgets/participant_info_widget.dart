
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_info.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/animation_setting.dart';
import 'package:group_study_app/widgets/line_profiles/participant_profile_widget.dart';
import 'package:group_study_app/widgets/tasks/task_group_widget.dart';

class ParticipantInfoWidget extends StatefulWidget {
  final ParticipantInfo participantInfo;
  final Function(String, int, Function(Task)) subscribe;
  final Function(String, int, Task) notify;
  final Study study;

  const ParticipantInfoWidget({
    Key? key,
    required this.participantInfo,
    required this.subscribe,
    required this.notify,
    required this.study,
  }) : super(key: key);

  @override
  State<ParticipantInfoWidget> createState() => _ParticipantInfoWidgetState();
}

class _ParticipantInfoWidgetState extends State<ParticipantInfoWidget> with TickerProviderStateMixin {
  late final Animation _animation;
  late final AnimationController _progressController =
    AnimationController(vsync: this, duration: AnimationSetting.animationDuration,);

  double _progress = 0;
  double _nextProgress = 0;

  @override
  void initState() {
    super.initState();
    _animation = CurvedAnimation(parent: _progressController, curve: Curves.easeInOut);
    _progressController.addListener(() {
      setState(() {
        _progress = lerpDouble(_progress, _nextProgress, _animation.value)!;
      });
    });

    _progress = widget.participantInfo.getTaskProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ParticipantProfileWidget(
          user: widget.participantInfo.participant,
          studyId: widget.study.studyId,
          taskProgress: _progress,),
        Design.padding24,

        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          primary: false,

          itemCount: widget.participantInfo.taskGroups.length,
          itemBuilder: (context, index) =>
              TaskGroupWidget(
                taskGroup: widget.participantInfo.taskGroups[index],
                subscribe: widget.subscribe,
                notify: widget.notify,
                updateProgress: _updateProgress,
                studyColor: widget.study.color,),
          separatorBuilder: (context, index) => Design.padding20,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void _updateProgress() {
    _nextProgress = widget.participantInfo.getTaskProgress();
    if (_progressController.isCompleted) {
      _progressController.reset();
    }

    _progressController.forward();
  }
}