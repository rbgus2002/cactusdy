import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/dialogs/two_button_dialog.dart';
import 'package:group_study_app/widgets/item_entry.dart';
import 'package:group_study_app/widgets/participant_info_list_widget.dart';
import 'package:group_study_app/widgets/tags/rectangle_tag.dart';

class RoundDetailRoute extends StatefulWidget {
  final int roundSeq;
  final int roundId;
  final int studyId;
  final Color studyColor;

  const RoundDetailRoute({
    Key? key,
    required this.roundSeq,
    required this.roundId,
    required this.studyId,
    required this.studyColor,
  }) : super(key: key);

  @override
  State<RoundDetailRoute> createState() => _RoundDetailRouteState();
}

class _RoundDetailRouteState extends State<RoundDetailRoute> {
  final _detailRecordEditingController = TextEditingController();
  final _focusNode = FocusNode();

  Round? round;
  bool _isEdited = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: InputBorder.none,
        actions: [ _roundPopupMenu(), ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border(bottom:
                    BorderSide(
                        color: context.extraColors.grey50!,
                        width: 7)),),
                child: FutureBuilder(
                  future: _getRoundDetail(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      round = snapshot.data;
                      _detailRecordEditingController.text = round!.detail ?? "";

                      return Container(
                        padding: Design.edgePadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Round Info
                            _roundInfo(),
                            Design.padding20,

                            // Detail Record
                            Text(
                              context.local.record,
                              style: TextStyles.head5.copyWith(
                                  color: context.extraColors.grey900),),
                            Design.padding8,
                            _detailRecord(),
                          ]),
                      );
                    }
                    return Design.loadingIndicator;
                  },),
              ),

              ParticipantInfoListWidget(
                  roundId: widget.roundId,
                  studyColor: widget.studyColor,),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _detailRecordEditingController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  Widget _roundDateBoxWidget() {
    return Container(
      width: 46,
      height: 56,
      decoration: BoxDecoration(
        color: widget.studyColor.withOpacity(0.2),
        borderRadius: Design.borderRadiusSmall,),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // if there are studyTime => [ Month, Day ]
          // else => [ Date, - ]

          // Month (or date)
          Text(
            (round?.studyTime != null)?
            '${round!.studyTime!.month}${context.local.month}' :
            context.local.date,
            style: TextStyles.body2.copyWith(
                color: context.extraColors.grey800),),

          // Day (or -)
          Text(
            (round?.studyTime != null) ?
            '${round!.studyTime!.day}' :
            '-',
            style: TextStyles.head3.copyWith(
                color: context.extraColors.grey800),),
        ],),);
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

              // Place And Time of round
              Row(
                children: [
                  Icon(CustomIcons.location, size: 14, color: context.extraColors.grey600),
                  Design.padding4,

                  // Study Place
                  Text(
                    (round!.studyPlace.isNotEmpty) ?
                      round!.studyPlace :
                      context.local.inputHint2(context.local.place),
                    style: TextStyles.body2.copyWith(color: context.extraColors.grey800),),
                  Design.padding4,

                  Icon(CustomIcons.calendar, size: 14, color: context.extraColors.grey600),
                  Design.padding4,

                  // Study Time (time only like AM 2:20)
                  Text(
                    (round!.studyTime != null) ?
                      TimeUtility.getTime(round!.studyTime!) :
                      context.local.inputHint1(context.local.time),
                    style: TextStyles.body2.copyWith(color: context.extraColors.grey800),),
                  Design.padding4,
                ],),
            ]),
        ),

        // Scheduled Tag
        Visibility(
          visible: TimeUtility.isScheduled(round!.studyTime),
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
      onTap: () { },  // Assert to do nothing.
    );
  }

  Widget _detailRecord() {
    return TextField(
      minLines: 4, maxLines: 7,
      maxLength: Round.detailMaxLength,
      controller: _detailRecordEditingController,
      style: TextStyles.body1.copyWith(color: context.extraColors.grey900),
      focusNode: _focusNode,
      decoration: InputDecoration(
        hintText: context.local.recordHint,
        hintStyle: TextStyles.body1.copyWith(color: context.extraColors.grey400),
        filled: true,
        fillColor: context.extraColors.grey50,
        border: const OutlineInputBorder(
          borderRadius: Design.borderRadius,
          borderSide: BorderSide.none,
          gapPadding: 16,)),
      onChanged: (value) { _isEdited = true; },
      onTapOutside: _updateDetail,
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

              buttonText1: context.local.delete,
              onPressed1: () => _deleteRound(context),
              isPrimary1: true,

              buttonText2: context.local.cancel,
              onPressed2: () { }, // Assert to do nothing
              isPrimary2: false),),
      ],
    );
  }

  Future<Round> _getRoundDetail() async {
    if (widget.roundId == Round.nonAllocatedRoundId) {
      Round newRound = Round(roundId: Round.nonAllocatedRoundId);
      await Round.createRound(newRound, widget.studyId);
      return newRound;
    }
    return Round.getDetail(widget.roundId);
  }

  void _updateDetail(PointerDownEvent notUseEvent) {
    if (_isEdited) {
      Round.updateDetail(widget.roundId, _detailRecordEditingController.text);
      _isEdited = false;
    }
    _focusNode.unfocus();
  }

  void _deleteRound(BuildContext context) async {
    try {
      await Round.deleteRound(round!.roundId).then((result) {
        if (result) Navigator.of(context).pop();
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