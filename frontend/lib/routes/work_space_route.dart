import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';

import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/circle_button.dart';
import 'package:group_study_app/widgets/round_info.dart';
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
                OutlineCircleButton(scale: 100.0, image: null, percent: 0.70, onTap: Test.onTabTest),
                UserLineProfile(scale: 50.0, image: null, onTap: Test.onTabTest, nickName: "NickName", comment: "Comment!",),
                UserList(userList: List<User>.generate(30, (index) => User(index, "d", "d")), onTap: Test.onTabTest),
                RoundInfo(roundIdx: 3, userList: List<User>.generate(30, (index) => User(index, "d", "d"))),
              ],
            )
          )
        )
    );
  }
}