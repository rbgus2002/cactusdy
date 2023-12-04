import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/dialogs/two_button_dialog.dart';
import 'package:group_study_app/widgets/input_field.dart';
import 'package:group_study_app/widgets/item_entry.dart';
import 'package:group_study_app/widgets/participant_info_list_widget.dart';
import 'package:group_study_app/widgets/tags/rectangle_tag.dart';

class RoundDetailRoute extends StatefulWidget {
  final int roundSeq;
  final int roundId;
  final Study study;
  final Function? onRemove;
  final bool reserved;

  const RoundDetailRoute({
    Key? key,
    required this.roundSeq,
    required this.roundId,
    required this.study,
    required this.reserved,
    this.onRemove,
  }) : super(key: key);

  @override
  State<RoundDetailRoute> createState() => _RoundDetailRouteState();
}

class _RoundDetailRouteState extends State<RoundDetailRoute> {
  final GlobalKey<InputFieldState> _detailEditor = GlobalKey();
  final _focusNode = FocusNode();

  Round? round;
  bool _isEdited = false;
  bool _reserved = false;

  @override
  void initState() {
    super.initState();
    _reserved = widget.reserved;
  }

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
                  future: Round.getDetail(widget.roundId),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      round = snapshot.data;
                      _reserved = TimeUtility.isScheduled(round!.studyTime);

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
                  reserved: _reserved,
                  roundId: widget.roundId,
                  study: widget.study,),
            ],
          ),
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // if there are studyTime => [ Month, Day ]
          // else => [ -Mon, - ]

          // Month (or date)
          Text(
            (round?.studyTime != null)?
            '${round!.studyTime!.month}${context.local.month}' :
            '-${context.local.month}',
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
      onTap: Util.doNothing,
    );
  }

  Widget _detailRecord() {
    return InputField(
      key: _detailEditor,
      initText: round!.detail,
      hintText: context.local.recordHint,
      minLines: 4,
      maxLines: 7,
      maxLength: Round.detailMaxLength,
      focusNode: _focusNode,
      backgroundColor: context.extraColors.grey50,
      onChanged: (input) => _isEdited = true,
      onTapOutSide: _updateDetail,
      counter: true,
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

              buttonText2: context.local.cancel,
              onPressed2: () { },),),
      ],
    );
  }

  void _updateDetail(PointerDownEvent notUseEvent) {
    if (_isEdited) {
      Round.updateDetail(widget.roundId, _detailEditor.currentState!.text);
      _isEdited = false;
    }
    _focusNode.unfocus();
  }

  void _deleteRound(BuildContext context) async {
    try {
      await Round.deleteRound(round!.roundId).then((result) {
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