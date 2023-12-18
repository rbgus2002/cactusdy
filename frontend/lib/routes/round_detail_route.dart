import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/date_time_picker_route.dart';
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
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Container(
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
                  bool reserved = TimeUtility.isScheduled(round!.studyTime);
                  _placeEditingController.text = round!.studyPlace;

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

                        ParticipantInfoListWidget(
                          reserved: reserved,
                          roundId: widget.roundId,
                          study: widget.study,),
                      ]),
                  );
                }
                return Design.loadingIndicator;
              },),
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

              // Place And Time of round
              Row(
                children: [
                  Icon(CustomIcons.calendar, size: 14, color: context.extraColors.grey600),
                  Design.padding4,

                  // Study Time (time only like AM 2:20)
                  InkWell(
                    onTap: () => Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
                        DateTimePickerRoute(round: round!,)).then((value) => _refresh()),
                    child: Text(
                      (round!.studyTime != null) ?
                        TimeUtility.getTime(round!.studyTime!) :
                        context.local.inputHint1(context.local.time),
                      style: (round!.studyTime != null) ?
                        TextStyles.body2.copyWith(color: context.extraColors.grey800) :
                        TextStyles.body2.copyWith(color: context.extraColors.grey800!.withOpacity(0.5)),),
                  ),
                  Design.padding4,

                  Icon(CustomIcons.location, size: 14, color: context.extraColors.grey600),
                  Design.padding4,

                  Expanded(
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
                      ),),
                  ),
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
  
  void _editStudyTime() async {
    Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
        DateTimePickerRoute(round: round!,)).then((value) => _refresh());
  }

  void _updateDetail(PointerDownEvent notUseEvent) {
    if (_isEdited) {
      Round.updateDetail(widget.roundId, _detailEditor.currentState!.text);
      _isEdited = false;

      _focusNode.unfocus();
    }
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