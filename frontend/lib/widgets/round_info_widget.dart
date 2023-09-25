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
import 'package:intl/intl.dart';

class RoundInfoWidget extends StatefulWidget {
  final int studyId;
  final int roundNum;
  Round round;

  RoundInfoWidget({
    super.key,
    required this.studyId,
    required this.roundNum,
    required this.round,
  });

  @override
  State<RoundInfoWidget> createState() => _RoundInformationWidget();
}

class _RoundInformationWidget extends State<RoundInfoWidget> {
  static const String _placeHintMessage = "장소를 입력해 주세요";
  static const String _timeHintMessage = "시간을 입력해 주세요";

  static const String _roundText = "회차";
  static const String _placeText = "장소";
  static const String _timeText = "시간";
  static const String _reserved = "예정됨";

  late final TextEditingController placeEditingController;
  bool _isEditable = false;
  bool _isEdited = false;
  @override
  void initState() {
    super.initState();
    placeEditingController =
        TextEditingController(text: widget.round.studyPlace);
  }

  @override
  Widget build(BuildContext context) {
    placeEditingController.text = widget.round.studyPlace??"";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row( // Round Text
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("${widget.roundNum}", style: TextStyles.numberTextStyle),
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

            if (widget.round.isPlanned == true)
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

                controller: placeEditingController,
                decoration: InputDecoration(
                  hintText: _placeHintMessage,
                  hintStyle: TextStyles.roundHintTextStyle,
                  isDense: true,
                  enabled: _isEditable,
                  contentPadding: EdgeInsets.zero,
                  disabledBorder: InputBorder.none,
                  counterText: "",
                ),
                onChanged: (value) { _isEdited = true; },
                onTapOutside: (event) { updatePlace(); },
                onSubmitted: (value) { updatePlace(); },
              ),

              // Time
              InkWell(
                enableFeedback: _isEditable,
                onTap: updateDateAndTime,
                child: Text((widget.round.studyTime != null)?
                  TimeUtility.timeToString(widget.round.studyTime!):_timeHintMessage,
                  maxLines: 1,
                  style: (widget.round.studyTime != null)? TextStyles.roundTextStyle:
                  TextStyles.roundHintTextStyle,
                ),
              )
            ],
          ),

          onTap: () {
            if (!_isEditable) {
              setState(() { _isEditable = true; });
            }
          },
        ),
      );
  }

  void updatePlace() {
    if (_isEditable) {
      if (_isEdited) {
        widget.round.studyPlace = placeEditingController.text;
        Round.updateAppointment(widget.round, widget.studyId);
        _isEdited = false;
      }
      _isEditable = false;
      setState(() {});
    }
  }

  void updateDateAndTime() async {
    TimeUtility.showDateTimePicker(context).then(
            (dateTime) {
              if (dateTime != null) {
                widget.round.studyTime = dateTime;
                Round.updateAppointment(widget.round, widget.studyId);
                widget.round.isPlanned = (dateTime.compareTo(DateTime.now()) > 0);
                setState(() { });
              }
            });
  }

  @override
  void dispose() {
    placeEditingController.dispose();
    super.dispose();
  }
}
