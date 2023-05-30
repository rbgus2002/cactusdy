import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/color_styles.dart';

import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/Tags/user_state_tag.dart';
import 'package:group_study_app/widgets/buttons/percent_circle_button.dart';
import 'package:group_study_app/widgets/charts/bar_chart.dart';
import 'package:group_study_app/widgets/charts/chart.dart';
import 'package:group_study_app/widgets/panels/round_info_panel.dart';
import 'package:group_study_app/widgets/user_line_profile.dart';

class WorkSpaceRoute extends StatefulWidget {
  const WorkSpaceRoute({super.key});

  @override
  State<StatefulWidget> createState() {
    return _WorkSpaceRoute();
  }
}

class _WorkSpaceRoute extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                PercentCircleButton(scale: 100.0, image: null, percentInfos: [ PercentInfo(percent: 0.6, color: ColorStyles.red)], onTap: Test.onTabTest),
                const UserLineProfile(scale: 50.0, image: null, onTap: Test.onTabTest, nickName: "NickName", comment: "Comment!",),
                const SizedBox(
                  height: 5,
                ),
                RoundInfoPanel(roundIdx: 3, place: "숭실대학교 정보과학관", date: DateTime.now(), userList: List<User>.generate(30, (index) => User(index, "d", "d"))),
                UserStateTag(text: "USE", color: Colors.red,),
                BarChart(percentInfos: [ PercentInfo(percent: 0.4, color: ColorStyles.red)
                , PercentInfo(percent: 0.1, color: ColorStyles.orange), PercentInfo(percent: 0.2, color: ColorStyles.green) ],
            stroke: 30,),
              ],
            )
          )
        )
    );
  }
}