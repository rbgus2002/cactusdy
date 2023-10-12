
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_info.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/animation_setting.dart';
import 'package:group_study_app/widgets/line_profiles/participant_line_profile_widget.dart';
import 'package:group_study_app/widgets/tasks/task_group_widget.dart';

class ParticipantInfoWidget extends StatefulWidget {
  final ParticipantInfo participantInfo;

  const ParticipantInfoWidget({
    Key? key,
    required this.participantInfo,
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
        ParticipantLineProfileWidget(
          user: widget.participantInfo.participant,
          taskProgress: _progress,
        ),
        Design.padding10,

        ListView.builder(
            shrinkWrap: true,
            primary: false,
            padding: EdgeInsets.zero,
            
            itemCount: widget.participantInfo.taskGroups.length,
            itemBuilder: _buildTaskGroup,
        )
      ],
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  Widget _buildTaskGroup(BuildContext context, int index) {
    return Container(
      padding: Design.bottom15,
      child: TaskGroupWidget(
          taskGroup: widget.participantInfo.taskGroups[index],
        updateProgress: updateProgress,
      )
    );
  }

  void updateProgress() {
    _nextProgress = widget.participantInfo.getTaskProgress();
    if (_progressController.isCompleted) {
      _progressController.reset();
    }

    _progressController.forward();
  }
}