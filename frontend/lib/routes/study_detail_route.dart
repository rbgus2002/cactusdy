import 'package:flutter/material.dart';
import 'package:group_study_app/models/participantSummary.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/notice_list_route.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/circle_button_list.dart';
import 'package:group_study_app/widgets/line_profiles/study_line_profile_widget.dart';
import 'package:group_study_app/widgets/panels/notice_list_panel.dart';
import 'package:group_study_app/widgets/buttons/outline_circle_button.dart';
import 'package:group_study_app/widgets/rule_widget.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class StudyDetailRoute extends StatefulWidget {
  const StudyDetailRoute({super.key});

  @override
  State<StudyDetailRoute> createState() {
    return _StudyDetailRoute();
  }
}

class _StudyDetailRoute extends State<StudyDetailRoute> {
  late Future<List<ParticipantSummary>> userList;
  late Future<Study> study;
  int studyId = 1; //< FIXME

  @override
  void initState() {
    super.initState();
    study = Study.getStudySummary(studyId);
    userList = ParticipantSummary.getParticipantsProfileImageList(studyId);
  }

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
            _participantsImages(),
            Design.padding15,

            //
            TitleWidget(title: "RULE", icon: AppIcons.edit,
                onTap: ()=> null,),
            RuleWidget(studyId: studyId),
            Design.padding15,

            const TitleWidget(title: "ROUND LIST", icon: AppIcons.add, onTap: Test.onTabTest),

            //RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: Test.testUserList),
            //RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: Test.testUserList),
            //RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: Test.testUserList),

          ],
        ),
      )
    );
  }

  Widget _participantsImages() {
    return FutureBuilder(
      future: userList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CircleButton> userImages = snapshot.data!.map((e) =>
              CircleButton(child: null, onTap: (){},
                  scale: 42),).toList();

          return CircleButtonList(circleButtons: userImages, paddingVertical: 5,);
        }
        else {
          return SizedBox();
        }
      }
    );
  }
}