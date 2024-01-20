
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/models/task.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/animation_setting.dart';
import 'package:groupstudy/widgets/line_profiles/participant_profile_widget.dart';
import 'package:groupstudy/widgets/tasks/task_group_widget.dart';

class ParticipantInfoWidget extends StatelessWidget {
  final ParticipantInfo participantInfo;
  final Function(String, int, Function(Task)) subscribe;
  final Function(String, int, String, List<TaskInfo>) notify;
  final Study study;
  final int roundId;
  final bool scheduled;

  final _progressController = GlobalKey<ProgressTextState>();

  ParticipantInfoWidget({
    super.key,
    required this.participantInfo,
    required this.roundId,
    required this.subscribe,
    required this.notify,
    required this.study,
    required this.scheduled,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ParticipantProfileWidget(
          roundParticipantId: participantInfo.roundParticipantId,
          user: participantInfo.participant,
          hostId: study.hostId,
          status: participantInfo.status,
          studyId: study.studyId,
          progressTextWidget: ProgressText(
            key: _progressController,
            initProgress: participantInfo.getTaskProgress(),),
          scheduled: scheduled,),
        Design.padding24,

        ListView.separated(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          primary: false,

          itemCount: participantInfo.taskGroups.length,
          itemBuilder: (context, index) =>
              TaskGroupWidget(
                userId: participantInfo.participant.userId,
                roundId: roundId,
                taskGroup: participantInfo.taskGroups[index],
                subscribe: subscribe,
                notify: notify,
                updateProgress: () {
                  _progressController.currentState!.updateProgress(
                      participantInfo.getTaskProgress());
                },
                study: study,),
          separatorBuilder: (context, index) => Design.padding20,
        ),
      ],
    );
  }
}

class ProgressText extends StatefulWidget {
  final double initProgress;

  const ProgressText({
    super.key,
    this.initProgress = 0,
  });

  @override
  State<ProgressText> createState() => ProgressTextState();
}

class ProgressTextState extends State<ProgressText> with TickerProviderStateMixin {
  late final Animation _animation;
  late final _progressController = AnimationController(
      vsync: this, duration: AnimationSetting.animationDuration,);

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

    _progress = widget.initProgress;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
        '${(_progress * 100).toStringAsFixed(1)}%',
        style: TextStyles.head5.copyWith(color: ColorStyles.mainColor)
    );
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  void updateProgress(double progress) {
    _nextProgress = progress;
    if (_progressController.isCompleted) {
      _progressController.reset();
    }

    _progressController.forward();
  }
}
