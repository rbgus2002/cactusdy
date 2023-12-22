
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:groupstudy/models/participant_info.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/models/task.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/animation_setting.dart';
import 'package:groupstudy/widgets/line_profiles/participant_profile_widget.dart';
import 'package:groupstudy/widgets/tasks/task_group_widget.dart';

class ParticipantInfoWidget extends StatefulWidget {
  final ParticipantInfo participantInfo;
  final Function(String, int, Function(Task)) subscribe;
  final Function(String, int, String, List<TaskInfo>) notify;
  final Study study;
  final bool reserved;

  final int roundId;

  const ParticipantInfoWidget({
    Key? key,
    required this.participantInfo,
    required this.roundId,
    required this.subscribe,
    required this.notify,
    required this.study,
    required this.reserved,
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
          roundParticipantId: widget.participantInfo.roundParticipantId,
          user: widget.participantInfo.participant,
          hostId: widget.study.hostId,
          status: widget.participantInfo.status,
          studyId: widget.study.studyId,
          taskProgress: _progress,
          reserved: widget.reserved,),
        Design.padding24,

        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          primary: false,

          itemCount: widget.participantInfo.taskGroups.length,
          itemBuilder: (context, index) =>
              TaskGroupWidget(
                userId: widget.participantInfo.participant.userId,
                roundId: widget.roundId,
                taskGroup: widget.participantInfo.taskGroups[index],
                subscribe: widget.subscribe,
                notify: widget.notify,
                updateProgress: _updateProgress,
                study: widget.study,),
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