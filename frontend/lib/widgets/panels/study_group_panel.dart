import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/Task/check_box_task.dart';
import 'package:group_study_app/widgets/circle_button.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/percent_graphs/percent_graph.dart';
import 'package:group_study_app/widgets/Task/task.dart';
import 'package:group_study_app/widgets/user_list_button.dart';
import 'package:group_study_app/widgets/round_info.dart';

class StudyGroupPanel extends Panel {
  StudyGroupPanel({
    super.key,
    super.backgroundColor,

    super.width,
    super.height,
    super.padding,
    }) : super(
      boxShadows: Design.basicShadows,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PercentCircleButton(scale: 60, percentInfos: [ PercentInfo(percent: 100, color: Colors.purple)]),
              Design.padding10,
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    const Text('STUDY GROUP NAME', style: TextStyles.titleLarge,),
                    UserListButton(
                      userList:
                      List<User>.generate(30, (index) => User(index, "d", "d")),
                      onTap: Test.onTabTest,
                      scale: 30.0,
                    ),
                  ]),
              ),
            ],
          ),
          Design.padding5,
          Container(
            color: Colors.red,
            alignment: Alignment.centerLeft,
            child: RoundInfo(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26),tag: "asd"),
          ),
          Design.padding5,
          Text("GROUP", style: TextStyles.titleSmall,),
          CheckBoxTask(taskid: 0, text: "백준 : 1203번 풀기"),
          CheckBoxTask(taskid: 0, text: "백준 : 23092번 풀기"),
          Design.padding15,
          Text("PERSONAL", style: TextStyles.titleSmall,),
          CheckBoxTask(taskid: 0, text: "알고리즘 강의 듣기"),
          CheckBoxTask(taskid: 0, text: "Flutter 강의 듣기"),
        ],
      )
    );
}