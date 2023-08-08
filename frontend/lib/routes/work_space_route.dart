import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';

import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/Tags/user_state_tag.dart';
import 'package:group_study_app/widgets/buttons/percent_circle_button.dart';
import 'package:group_study_app/widgets/charts/bar_chart.dart';
import 'package:group_study_app/widgets/charts/chart.dart';
import 'package:group_study_app/widgets/dialogs/user_profile_dialog.dart';
import 'package:group_study_app/widgets/panels/notice_panel.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/panels/round_info_panel.dart';
import 'package:group_study_app/widgets/round_info_widget.dart';
import 'package:group_study_app/widgets/tags/study_group_tag.dart';
import 'package:group_study_app/widgets/line_profiles/user_line_profile.dart';

class WorkSpaceRoute extends StatefulWidget {
  const WorkSpaceRoute({super.key});

  @override
  State<WorkSpaceRoute> createState() {
    return _WorkSpaceRoute();
  }
}

class _WorkSpaceRoute extends State<WorkSpaceRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                PercentCircleButton(scale: 60.0, image: null, percentInfos: [ PercentInfo(percent: 0.6, color: ColorStyles.red)], onTap: () { UserProfileDialog.showProfileDialog(context); }),
                //const UserLineProfile(scale: 50.0, image: null, onTap: Test.onTabTest, nickName: "NickName", comment: "Comment!",),
                const SizedBox(
                  height: 5,
                ),
                //RoundInfoPanel(roundIdx: 3, place: "숭실대학교 정보과학관", date: DateTime.now(), userList: List<User>.generate(30, (index) => User(index, "d", "d"))),
                //RoundInfo(roundIdx: 3, tag: "TAG"),

                UserStateTag(text: "USE", color: Colors.red,),
                BarChart(percentInfos: [ PercentInfo(percent: 0.4, color: ColorStyles.red)
                , PercentInfo(percent: 0.1, color: ColorStyles.orange), PercentInfo(percent: 0.2, color: ColorStyles.green) ], stroke: 30,),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      StudyGroupTag(color: ColorStyles.red, name: "Algorithm",),
                      StudyGroupTag(color: ColorStyles.orange, name: "TOEIC"),

                      StudyGroupTag(color: ColorStyles.orange, name: "TOEIC"),
                      StudyGroupTag(color: ColorStyles.orange, name: "TOEIC"),

                    ],
                  ),
                ),
                Panel(
                  boxShadows: Design.basicShadows,
                  child: NoticePanel(
                    noticeSummary: NoticeSummary(
                        noticeId: 1213,
                        writerNickname: "Aaa",
                    title: "[공지] 내일까지 적당히 긴 제목 만들어 오기",
                    createDate: DateTime.now(),
                    pinYn: true,
                    contents: "적당히 긴 내용 뭐가 있을까"),
                  ),
                )
              ],
            )
          )
        )
    );
  }
}