import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';

import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/circle_button.dart';
import 'package:group_study_app/widgets/panels/round_info_panel.dart';
import 'package:group_study_app/widgets/percent_graphs/percent_graph.dart';
import 'package:group_study_app/widgets/tag.dart';
import 'package:group_study_app/widgets/user_line_profile.dart';
import 'package:group_study_app/widgets/user_list_button.dart';

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
                UserStateTag(text: "USE", color: Colors.red,)
              ],
            )
          )
        )
    );
  }
}