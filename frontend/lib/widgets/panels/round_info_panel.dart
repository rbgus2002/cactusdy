import 'package:flutter/material.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/round_info.dart';
import 'package:group_study_app/widgets/circle_button_list.dart';

import '../../themes/design.dart';
import '../../utilities/test.dart';

class RoundInfoPanel extends Panel {
  final int roundIdx;
  final String? place;
  final DateTime? date;
  final List<CircleButton> userList; //< FIXME need to be renamed

  final onTap;

  RoundInfoPanel({
    super.key,
    super.backgroundColor,

    super.width,
    super.height,
    super.padding,

    required this.roundIdx,
    this.place,
    this.date,
    required this.userList,
    this.onTap,
  }) : super(
    boxShadows: Design.basicShadows,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children : [
            RoundInfo(roundIdx: roundIdx, place: place, date: date, tag: "ASd"),
            Icon(Icons.chevron_right),
          ],
        ),
        if (!userList.isEmpty)
          Design.padding10,

        /*< FIXME
        CircleButtonList(
          circleButtons: userList,
          onTap: Test.onTabTest,
          scale: 42.0,
        ),
         */
      ],
    )
  );
}
