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
import 'package:intl/intl.dart';

class RoundInformationWidget extends StatefulWidget {
  final Animation<double> animation;
  final Round round;

  RoundInformationWidget({
    super.key,
    required this.round,
    required this.animation,
  });

  @override
  State<RoundInformationWidget> createState() => _RoundInformationWidget();
}

class _RoundInformationWidget extends State<RoundInformationWidget> {
  static const String _placeHintMessage = "장소를 입력해 주세요";

  late final TextEditingController placeEditingController;
  bool _isEditable = false;
  @override
  void initState() {
    super.initState();
    placeEditingController = TextEditingController(text: widget.round.place);
  }

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: widget.animation,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row( // Round Text
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("${widget.round.roundIdx}", style: TextStyles.titleBig),
                  const Text("회차", style: TextStyles.titleSmall,)
                ]
              ),
              Design.padding15,

              Flexible(
                fit: FlexFit.tight,
                child: GestureDetector(
                  onTap: () {
                    if (!_isEditable) {
                      setState(() { _isEditable = true; });
                    }
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        maxLines: 1,
                        style: TextStyles.roundTextStyle,

                        controller: placeEditingController,
                        decoration: InputDecoration(
                          hintText: _placeHintMessage,
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
                      InkWell(
                        onTap: () async {
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
                        },
                        enableFeedback: _isEditable,
                        child: Text((widget.round.date != null)?DateFormat('yyyy-MM-dd').format(widget.round.date!):'시간을 입력해주세요',
                          maxLines: 1, style: TextStyles.titleTiny,
                        ),
                      )
                    ],
                  ),
                ),
              ),

              UserStateTag(color: Colors.red, text: "예정됨"),
            ],
          ),

          CircleButtonList(
            circleButtons: Test.testUserList.map((e) {
              double percent = Random.secure().nextDouble();
              return PercentCircleButton(percentInfos: [ PercentInfo(percent: percent, color: (percent > 0.5)?ColorStyles.green : ColorStyles.red)], scale: 42, onTap: (){},
            ); }).toList(),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    placeEditingController.dispose();
    super.dispose();
  }
}
