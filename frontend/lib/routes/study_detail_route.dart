import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/notice_list_route.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/circle_button_list.dart';
import 'package:group_study_app/widgets/line_profiles/study_line_profile_widget.dart';
import 'package:group_study_app/widgets/panels/notice_list_panel.dart';
import 'package:group_study_app/widgets/buttons/outline_circle_button.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class StudyDetailRoute extends StatefulWidget {
  @override
  State<StudyDetailRoute> createState() {
    return _StudyDetailRoute();
  }
}

class _StudyDetailRoute extends State<StudyDetailRoute> {
  List<User> userList = List<User>.generate(30, (index) => User(userId: 0, nickname: "d", statusMessage: "", picture: ""));
  
  int studyId = 1; //< FIXME

  Study study = const Study(studyId: 1, studyName: "스터디", detail: "additional comment", picture: "");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Design.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Design.padding15,

            // Study Head
            StudyLineProfileWidget(study: study),
            Design.padding15,

            // Notice
            TitleWidget(title: "NOTICE", icon: AppIcons.chevronRight,
              onTap: () => Util.pushRoute(context, (context)=>NoticeListRoute())),
            NoticeListPanel(noticeId: studyId,),
            Design.padding15,

            //
            TitleWidget(title: "MEMBER", icon: AppIcons.add,
              onTap: () => null,),
            FutureBuilder(
                future: ,
                builder: )

            CircleButtonList(circleButtons: userList,),
            Design.padding15,

            //
            const TitleWidget(title: "RULE", icon: Icon(Icons.edit, size: 18,)),
            Design.padding15,

            const TitleWidget(title: "ROUND LIST", icon: Icon(Icons.add), onTap: Test.onTabTest),

            //RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: Test.testUserList),
            //RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: Test.testUserList),
            //RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: Test.testUserList),

          ],
        ),
      )
    );
  }
}