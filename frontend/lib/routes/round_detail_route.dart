import 'package:flutter/material.dart';
import 'package:groupstudy/models/round.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/date_time_picker_route.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/animation_setting.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/time_utility.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/dialogs/two_button_dialog.dart';
import 'package:groupstudy/widgets/input_field.dart';
import 'package:groupstudy/widgets/input_field_place.dart';
import 'package:groupstudy/widgets/item_entry.dart';
import 'package:groupstudy/widgets/participant_info_list_widget.dart';
import 'package:groupstudy/widgets/tags/rectangle_tag.dart';

class RoundDetailRoute extends StatefulWidget {
  final int roundSeq;
  final int roundId;
  final Study study;
  final Function? onRemove;

  const RoundDetailRoute({
    Key? key,
    required this.roundSeq,
    required this.roundId,
    required this.study,
    this.onRemove,
  }) : super(key: key);

  @override
  State<RoundDetailRoute> createState() => _RoundDetailRouteState();
}

class _RoundDetailRouteState extends State<RoundDetailRoute> {
  late final TextEditingController _placeEditingController = TextEditingController();
  final GlobalKey<InputFieldState> _detailEditor = GlobalKey();

  final _focusNode = FocusNode();

  late Round round;
  bool _isEdited = false;
  bool _isExpended = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: InputBorder.none,
        actions: [ _roundPopupMenu(), ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder(
              future: Round.getDetail(widget.roundId),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  round = snapshot.data!;
                  bool reserved = TimeUtility.isScheduled(round.studyTime);
                  _placeEditingController.text = round.studyPlace;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Round Info & Detail Record
                      Container(
                        padding: Design.edgePadding,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: context.extraColors.grey50!,
                              width: 7),),),
                        child: Column(
                          children: [
                            // Round Info
                            _roundInfo(),
                            Design.padding12,

                            // Detail Record
                            _detailRecord(),
                            Design.padding12,
                          ],),
                      ),

                      // Participant Information List
                      ParticipantInfoListWidget(
                        reserved: reserved,
                        roundId: widget.roundId,
                        study: widget.study,),
                    ]);
                }
                return Design.loadingIndicator;
              },),
          ),
      ),
    );
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _roundDateBoxWidget() {
    return Container(
      width: 46,
      height: 56,
      decoration: BoxDecoration(
        color: widget.study.color.withOpacity(0.2),
        borderRadius: Design.borderRadiusSmall,),
      child: InkWell(
        onTap: _editStudyTime,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            // if there are studyTime => [ Month, Day ]
            // else => [ -Mon, - ]

            // Month (or date)
            Text(
              (round.studyTime != null)?
              '${round.studyTime!.month}${context.local.month}' :
              '-${context.local.month}',
              style: TextStyles.body2.copyWith(
                  color: context.extraColors.grey800),),

            // Day (or -)
            Text(
              (round.studyTime != null) ?
              '${round.studyTime!.day}' :
              '-',
              style: TextStyles.head3.copyWith(
                  color: context.extraColors.grey800),),
          ],),
      ),);
  }

  Widget _roundInfo() {
    return Row(
      children: [
        _roundDateBoxWidget(),
        Design.padding12,

        Flexible(
          fit: FlexFit.tight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Round Sequence (Like 3Round)
              Text(
                '${widget.roundSeq}${context.local.round}',
                style: TextStyles.head5.copyWith(color: context.extraColors.grey800),),
              Design.padding4,

              // Time And Place of round
              Row(
                children: [
                  // Study Time (time only like AM 2:20)
                  Icon(CustomIcons.calendar, size: 14, color: context.extraColors.grey600),
                  Design.padding4,

                  InkWell(
                    onTap: _editStudyTime,
                    child: Text(
                      (round.studyTime != null) ?
                        TimeUtility.getTime(round.studyTime!) :
                        context.local.inputHint1(context.local.time),
                      style: (round.studyTime != null) ?
                        TextStyles.body2.copyWith(color: context.extraColors.grey800) :
                        TextStyles.body2.copyWith(color: context.extraColors.grey800!.withOpacity(0.5)),),
                  ),
                  Design.padding4,

                  // Study Place
                  Icon(CustomIcons.location, size: 14, color: context.extraColors.grey600),
                  Design.padding4,

                  Expanded(
                    child: InputFieldPlace(
                      placeEditingController: _placeEditingController,
                      onUpdatePlace: _updateStudyPlace,),),
                  Design.padding4,
                ],),
            ]),
        ),

        // Scheduled Tag
        Visibility(
          visible: TimeUtility.isScheduled(round.studyTime),
          child: _scheduleTag()),
      ],
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
      onTap: Util.doNothing,
    );
  }

  Widget _detailRecord() {
    return ExpansionTile(
      initiallyExpanded: true,
      title: Text(
        context.local.record,
        style: TextStyles.head5.copyWith(
            color: context.extraColors.grey900),),
      onExpansionChanged: (value) => setState(() => _isExpended = !_isExpended),
      trailing: AnimatedRotation(
        turns: (_isExpended) ? 0 : 0.5,
        duration: AnimationSetting.animationDurationShort,
        curve: Curves.easeOutCirc,
        child: Icon(
          CustomIcons.chevron_down,
          color: context.extraColors.grey500,),),
      children: [
        InputField(
          key: _detailEditor,
          initText: round.detail,
          hintText: context.local.recordHint,
          minLines: 4,
          maxLines: 7,
          maxLength: Round.detailMaxLength,
          focusNode: _focusNode,
          backgroundColor: context.extraColors.grey50,
          onChanged: (input) => _isEdited = true,
          onTapOutSide: _updateDetail,
          counter: true,),
      ],
    );
  }

  Widget _roundPopupMenu() {
    return PopupMenuButton(
      icon: const Icon(CustomIcons.more_vert),
      splashRadius: 16,
      position: PopupMenuPosition.under,
      constraints: const BoxConstraints(minWidth: Design.popupWidth),
      itemBuilder: (context) => [
        ItemEntry(
          text: context.local.deleteRound,
          icon: const Icon(CustomIcons.trash),
          onTap: () => TwoButtonDialog.showProfileDialog(
              context: context,
              text: context.local.deleteRound,

              buttonText1: context.local.no,
              onPressed1: Util.doNothing,

              buttonText2: context.local.delete,
              onPressed2: () => _deleteRound(context),),),
      ],
    );
  }

  Future<void> _refresh() async {
    setState(() {});
  }

  void _updateDetail(PointerDownEvent notUseEvent) {
    if (_isEdited) {
      Round.updateDetail(widget.roundId, _detailEditor.currentState!.text);
      _isEdited = false;
    }

    _focusNode.unfocus();
  }

  void _updateStudyPlace() {
    round.studyPlace = _placeEditingController.text;
    _updateRound(round);
  }

  void _editStudyTime() async {
    Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
        DateTimePickerRoute(round: round,)).then((value) => _refresh());
  }

  Future<void> _updateRound(Round round) async {
    if (round.roundId == Round.nonAllocatedRoundId) {
      await Round.createRound(round, widget.study.studyId);
    }
    else {
      await Round.updateAppointment(round);
    }

    _refresh();
  }

  void _deleteRound(BuildContext context) async {
    try {
      await Round.deleteRound(round.roundId).then((result) {
        if (result) {
          Navigator.of(context).pop();

          if (widget.onRemove != null) {
            widget.onRemove!();
          }
        }
      });
    } on Exception catch(e) {
      if (mounted) {
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }
}