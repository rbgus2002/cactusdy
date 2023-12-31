
import 'package:flutter/material.dart';
import 'package:groupstudy/models/round.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/date_time_picker_route.dart';
import 'package:groupstudy/routes/round_detail_route.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/time_utility.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/squircle_widget.dart';
import 'package:groupstudy/widgets/diagrams/dash_line.dart';
import 'package:groupstudy/widgets/input_field_place.dart';
import 'package:groupstudy/widgets/profile_lists/participant_profile_list_widget.dart';
import 'package:groupstudy/widgets/tags/rectangle_tag.dart';

class RoundSummaryWidget extends StatefulWidget {
  final int roundSeq;
  final Round round;
  final Study study;
  final Function(int) onRemove;
  final List<ParticipantProfile> participantProfileList;

  const RoundSummaryWidget({
    Key? key,
    required this.roundSeq,
    required this.round,
    required this.study,
    required this.onRemove,
    required this.participantProfileList,
  }) : super(key: key);

  @override
  State<RoundSummaryWidget> createState() => _RoundSummaryWidgetState();
}

class _RoundSummaryWidgetState extends State<RoundSummaryWidget> {
  static const Color _color = ColorStyles.mainColor;

  late final TextEditingController _placeEditingController;

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _placeEditingController =
        TextEditingController(text: widget.round.studyPlace);
  }

  @override
  Widget build(BuildContext context) {
    _placeEditingController.text = widget.round.studyPlace;

    return InkWell(
      onTap: _viewRound,
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              SquircleWidget(
                scale: 32,
                side: BorderSide.none,
                backgroundColor: ColorStyles.mainColor,
                child: Center(
                  child: Text(
                    '${widget.roundSeq}',
                    style: TextStyles.head5.copyWith(
                        color: context.extraColors.grey000),),),),

              (TimeUtility.isHeld(widget.round.studyTime))?
                  const DashLine(color: ColorStyles.mainColor, bold: true,) :
                  DashLine(color: context.extraColors.grey500!,),
            ],),
          Design.padding8,

          Flexible(
            child: Column(
              children: [
                Design.padding4,
                _titleLine(),
                Design.padding16,

                _bodyBox(),
                Design.padding(32),
              ],),),
        ],),
    );
  }

  @override
  void dispose() {
    _placeEditingController.dispose();
    super.dispose();
  }

  Widget _titleLine() {
    return Row(
      children: [
        Text(
          context.local.round,
          style: TextStyles.head5.copyWith(color: _color),),
        Design.padding4,

        // Scheduled Tag
        Visibility(
          visible: TimeUtility.isScheduled(widget.round.studyTime),
          child: _scheduleTag()),

        const Spacer(),
        IconButton(
          icon: const Icon(CustomIcons.chevron_right),
          iconSize: 24,
          splashRadius: 12,
          padding: EdgeInsets.zero,
          color: context.extraColors.grey400,
          constraints: const BoxConstraints(),
          onPressed: _viewRound,),
      ],
    );
  }

  Widget _bodyBox() {
    return Container(
      padding: Design.edge16,
      decoration: BoxDecoration(
        color: context.extraColors.grey100,
        borderRadius: Design.borderRadiusSmall,),
      child: Column(
          children: [
            _timeWidget(),
            Design.padding4,

            _placeWidget(),
            Design.padding16,

            ParticipantProfileListWidget(
                roundParticipantSummaries: widget.participantProfileList,
                studyId: widget.study.studyId)
          ],),
    );
  }

  Widget _scheduleTag() {
    return RectangleTag(
      width: 36,
      height: 22,
      color: context.extraColors.pink!,
      text: Text(
        context.local.scheduled,
        style: TextStyles.caption2.copyWith(
          color: context.extraColors.grey800,),),
      onTap: _viewRound,
    );
  }

  Widget _placeWidget() {
    return Row(
      children: [
        Icon(
          CustomIcons.location,
          size: 14, color:
          context.extraColors.grey600,),

        Design.padding4,
        Flexible(
          child: InputFieldPlace(
            placeEditingController: _placeEditingController,
            onUpdatePlace: _updateStudyPlace,),),
      ],
    );
  }

  Widget _timeWidget() {
    return Row(
      children: [
        Icon(
          CustomIcons.calendar,
          size: 14,
          color: context.extraColors.grey600,),
        Design.padding4,

        InkWell(
          onTap: _editStudyTime,
          child: Text(
            (widget.round.studyTime != null) ?
              TimeUtility.timeToString(widget.round.studyTime!) :
              context.local.inputHint1(context.local.time),
            maxLines: 1,
            style: TextStyles.body2.copyWith(
                color: context.extraColors.grey800!.withOpacity(
                    (widget.round.studyTime != null)? 1 : 0.5),),),
        ),
      ],
    );
  }

  void _viewRound() async {
    if (!_isProcessing) {
      _isProcessing = true;

      if (widget.round.roundId == Round.nonAllocatedRoundId) {
        await Round.createRound(widget.round, widget.study.studyId);
      }

      if (context.mounted) {
        Util.pushRoute(context, (context) =>
            RoundDetailRoute(
              roundSeq: widget.roundSeq,
              round: widget.round,
              study: widget.study,
              onRemove: () => widget.onRemove(widget.roundSeq),))
          .then((value) => setState(() { } ));
      }

      _isProcessing = false;
    }
  }

  void _updateStudyPlace() {
    widget.round.studyPlace = _placeEditingController.text;
    _updateRound(widget.round);
  }

  void _editStudyTime() async {
    Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
        DateTimePickerRoute(round: widget.round,)).then((value) => setState((){ }));
  }

  void _updateRound(Round round) async {
    if (round.roundId == Round.nonAllocatedRoundId) {
      await Round.createRound(round, widget.study.studyId);
    }
    else {
      await Round.updateAppointment(round);
    }

    setState(() { });
  }
}