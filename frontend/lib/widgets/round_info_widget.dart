import 'dart:math';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/Tags/user_state_tag.dart';
import 'package:group_study_app/widgets/buttons/percent_circle_button.dart';
import 'package:group_study_app/widgets/charts/chart.dart';
import 'package:group_study_app/widgets/circle_button_list.dart';
import 'package:group_study_app/widgets/dialogs/user_profile_dialog.dart';
import 'package:intl/intl.dart';

class RoundInfoWidget extends StatefulWidget {
  final int roundNum;
  final Round round;

  const RoundInfoWidget({
    super.key,
    required this.roundNum,
    required this.round,
  });

  @override
  State<RoundInfoWidget> createState() => _RoundInformationWidget();
}

class _RoundInformationWidget extends State<RoundInfoWidget> {
  static const String _placeHintMessage = "장소를 입력해 주세요";

  late final TextEditingController placeEditingController;
  bool _isEditable = false;
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
                Text("${widget.roundNum}", style: TextStyles.titleBig),
                const Text("회차", style: TextStyles.titleSmall,)
              ]
            ),
            Design.padding10,
            const Column(
              children: [
                Text('장소:', style: TextStyles.roundTextStyle,),
                Text('시간:', style: TextStyles.roundTextStyle,),
              ],
            ),
            _studyTimeAndPlace(),

            if (widget.round.isPlanned == true)
              UserStateTag(color: Colors.red, text: "예정됨"),
          ],
        ),

        CircleButtonList(
          circleButtons: widget.round.roundParticipantInfos.map((r) {
            double percent = Random.secure().nextDouble();
            return PercentCircleButton(
              image: null, //< FXIME
              percentInfos: [ PercentInfo(percent: percent, color: (percent > 0.5)?ColorStyles.green : ColorStyles.red)], scale: 42,
              onTap: () => UserProfileDialog.showProfileDialog(context,1),//< FIXME
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
                maxLines: 1,
                style: TextStyles.roundTextStyle,

                controller: placeEditingController,
                decoration: InputDecoration(
                  hintText: _placeHintMessage,
                  hintStyle: TextStyles.roundTextStyle,
                  isDense: true,
                  enabled: _isEditable,
                  contentPadding: EdgeInsets.zero,
                  disabledBorder: InputBorder.none,
                ),
                onTapOutside: (event) {
                  if (_isEditable) {
                    setState(() { _isEditable = false; });
                  }
                },
              ),

              // Time
              InkWell(
                enableFeedback: _isEditable,
                child: Text((widget.round.studyTime != null)?DateFormat('yyyy-MM-dd').format(widget.round.studyTime!):'시간을 입력해주세요',
                  maxLines: 1, style: TextStyles.titleTiny,
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

  void getDateAndTime() async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (selectedDate != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
    }
  }

  @override
  void dispose() {
    placeEditingController.dispose();
    super.dispose();
  }
}
