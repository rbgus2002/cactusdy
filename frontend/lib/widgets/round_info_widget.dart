import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/time_utility.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/Tags/user_state_tag.dart';
import 'package:group_study_app/widgets/buttons/percent_circle_button.dart';
import 'package:group_study_app/widgets/charts/chart.dart';
import 'package:group_study_app/widgets/circle_button_list.dart';
import 'package:group_study_app/widgets/dialogs/user_profile_dialog.dart';


class RoundInfoWidget extends StatefulWidget {
  final int roundSeq;
  final Round round;
  final int studyId;

  const RoundInfoWidget({
    Key? key,
    required this.roundSeq,
    required this.round,
    required this.studyId,
  }) : super(key: key);

  @override
  State<RoundInfoWidget> createState() => _RoundInformationWidget();
}

class _RoundInformationWidget extends State<RoundInfoWidget> {
  static const String _placeHintText = "장소를 입력해 주세요";
  static const String _timeHintText = "시간을 입력해 주세요";

  static const String _roundText = "회차";
  static const String _placeText = "장소";
  static const String _timeText = "시간";
  static const String _reserved = "예  정";

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
    _placeEditingController.text = widget.round.studyPlace??"";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row( // Round Text
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${widget.roundSeq}", style: TextStyles.numberTextStyle),
                const Text(_roundText, style:
                  TextStyle(fontSize: 16, fontWeight: FontWeight.bold, height: 2)),
              ]
            ),
            Design.padding10,
            const Column(
              children: [
                Text('$_placeText : ', style: TextStyles.roundTextStyle,),
                Text('$_timeText : ', style: TextStyles.roundTextStyle,),
              ],
            ),
            _studyTimeAndPlace(),

            if (_isScheduled())
              UserStateTag(color: Colors.red, text: _reserved),
          ],
        ),

        CircleButtonList(
          circleButtons: widget.round.roundParticipantInfos.map((r) {
            Color outlineColor = Util.progressToColor(r.taskProgress);

            return PercentCircleButton(
              image: null, //< FIXME
              scale: 42,
              percentInfos: [ PercentInfo(percent: r.taskProgress, color: outlineColor)],
              onTap: () => UserProfileDialog.showProfileDialog(context, r.userId),//< FIXME
          ); }).toList(),
        )
      ],
    );
  }

  bool _isScheduled() {
    return (widget.round.studyTime != null
        && widget.round.studyTime!.compareTo(DateTime.now()) > 0);
  }

  Widget _studyTimeAndPlace() {
    return Flexible(
        fit: FlexFit.tight,
        child: GestureDetector(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Place
              TextField(
                maxLength: Round.placeMaxLength,
                maxLines: 1,
                style: TextStyles.roundTextStyle,

                controller: _placeEditingController,
                decoration: const InputDecoration(
                  hintText: _placeHintText,
                  hintStyle: TextStyles.roundHintTextStyle,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,

                  border: InputBorder.none,
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: ColorStyles.taskTextColor)),
                  counterText: "",
                ),

                onChanged: (value) => _isEdited = true,
                onTapOutside: (event) => updatePlace(),
                onSubmitted: (value) => updatePlace(),
              ),

              // Time
              InkWell(
                onTap: updateDateAndTime,
                child: Text((widget.round.studyTime != null)?
                  TimeUtility.timeToString(widget.round.studyTime!):_timeHintText,
                  maxLines: 1,
                  style: (widget.round.studyTime != null)? TextStyles.roundTextStyle:
                  TextStyles.roundHintTextStyle,
                ),
              )
            ],
          ),
        ),
      );
  }

  void updatePlace() {
    if (_isEdited) {
      widget.round.studyPlace = _placeEditingController.text;
      updateRound(widget.round);
      _isEdited = false;
    }
    setState(() {});
  }

  void updateDateAndTime() async {
    TimeUtility.showDateTimePicker(context).then(
            (dateTime) {
              if (dateTime != null) {
                widget.round.studyTime = dateTime;
                updateRound(widget.round);

                setState(() { });
              }
            });
  }

  void updateRound(Round round) {
    if (round.roundId == Round.nonAllocatedRoundId) {
      Round.createRound(round, widget.studyId);
    }
    else {
      Round.updateAppointment(round);
    }
  }

  @override
  void dispose() {
    _placeEditingController.dispose();
    super.dispose();
  }
}
