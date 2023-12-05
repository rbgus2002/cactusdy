
import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/date_time_picker_route.dart';
import 'package:group_study_app/routes/round_detail_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';
import 'package:group_study_app/widgets/diagrams/dash_line.dart';
import 'package:group_study_app/widgets/participant_list_widget.dart';
import 'package:group_study_app/widgets/tags/rectangle_tag.dart';

class RoundSummaryWidget extends StatefulWidget {
  final int roundSeq;
  final Round round;
  final Study study;
  final Function(int) onRemove;

  const RoundSummaryWidget({
    Key? key,
    required this.roundSeq,
    required this.round,
    required this.study,
    required this.onRemove,
  }) : super(key: key);

  @override
  State<RoundSummaryWidget> createState() => _RoundSummaryWidgetState();
}

class _RoundSummaryWidgetState extends State<RoundSummaryWidget> {
  static const Color _color = ColorStyles.mainColor;

  late final TextEditingController _placeEditingController;
  bool _isEdited = false;

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
      onTap: _lookUpRound,
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
          onPressed: _lookUpRound,),
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

            ParticipantListWidget(
              roundParticipantInfoList: widget.round.roundParticipantInfos,
              studyId: widget.study.studyId,),
          ],),
    );
  }

  Widget _scheduleTag() {
    return RectangleTag(
      width: 40,
      height: 22,
      color: context.extraColors.reservedTagColor!,
      text: Text(
        context.local.reserved,
        style: TextStyles.caption2.copyWith(
          color: context.extraColors.grey000,),),
      onTap: _lookUpRound,
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
          child: TextField(
            maxLength: Round.placeMaxLength,
            maxLines: 1,
            style: TextStyles.body2.copyWith(
                color: context.extraColors.grey800),

            controller: _placeEditingController,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.zero,

              hintText: context.local.inputHint2(context.local.place),
              hintStyle: TextStyles.body2.copyWith(
                  color: context.extraColors.grey800!.withOpacity(0.5)),

              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: context.extraColors.grey700!,)),
              counterText: "",
            ),

            onChanged: (value) => _isEdited = true,
            onTapOutside: (event) => _updateStudyPlace(),
            onSubmitted: (value) => _updateStudyPlace(),
          ),
        ),
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

  void _lookUpRound() async {
    if (widget.round.roundId == Round.nonAllocatedRoundId) {
      await Round.createRound(widget.round, widget.study.studyId);
    }

    if (context.mounted) {
      Util.pushRoute(context, (context) =>
          RoundDetailRoute(
            reserved: TimeUtility.isScheduled(widget.round.studyTime),
            roundSeq: widget.roundSeq,
            roundId: widget.round.roundId, study: widget.study,
            onRemove: () => widget.onRemove(widget.roundSeq),));
    }
  }

  void _updateStudyPlace() {
    if (_isEdited) {
      widget.round.studyPlace = _placeEditingController.text;
      _updateRound(widget.round);
      _isEdited = false;
    }
    setState(() {});
  }

  void _editStudyTime() async {
    Util.pushRoute(context, (context) =>
        DateTimePickerRoute(
          round: widget.round,)).then((value) => setState((){ }));
  }

  void _updateRound(Round round) {
    if (round.roundId == Round.nonAllocatedRoundId) {
      Round.createRound(round, widget.study.studyId);
    }
    else {
      Round.updateAppointment(round);
    }
  }
}