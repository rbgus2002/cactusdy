import 'package:flutter/material.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/widgets/Tags/tag.dart';
import 'package:group_study_app/widgets/Tags/user_state_tag.dart';
import 'package:intl/intl.dart';

import '../themes/design.dart';
import '../themes/text_styles.dart';

class RoundInfo extends StatelessWidget {
  final int roundIdx;
  final String? place;
  final DateTime? date;
  final String tag;

  RoundInfo({
    Key? key,
    required this.roundIdx,
    required this.tag,
    this.place,
    this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row( // Round Text
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("$roundIdx", style: TextStyles.titleBig),
                  const Text("회차", style: TextStyles.titleSmall,)
                ]
            ),
            Design.padding15,

            Flexible(
              fit: FlexFit.tight,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(place ?? "장소를 입력해 주세요", maxLines: 1,
                      style: TextStyles.titleTiny),
                  Text(DateFormat('yyyy-MM-dd').format(date ?? DateTime.now()),
                    maxLines: 1, style: TextStyles.titleTiny,),
                ],
              ),
            ),

            UserStateTag(color: Colors.red, text: "예정됨"),
          ],
        )
    );
  }
}
