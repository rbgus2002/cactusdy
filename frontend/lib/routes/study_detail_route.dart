import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_summary.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/notice_list_route.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/list_model.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/circle_button.dart';
import 'package:group_study_app/widgets/circle_button_list.dart';
import 'package:group_study_app/widgets/dialogs/user_profile_dialog.dart';
import 'package:group_study_app/widgets/line_profiles/study_line_profile_widget.dart';
import 'package:group_study_app/widgets/panels/notice_summary_panel.dart';
import 'package:group_study_app/widgets/round_info_list_widget.dart';
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
  final int studyId = Test.testStudy.studyId; //< FIXME
  final int userId = Test.testUser.userId;


  // is this right?
  final GlobalKey<RoundInfoListWidgetState> _roundInformationListKey = GlobalKey<RoundInfoListWidgetState>();

  late ListModel<Round> _roundList;

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
            NoticeSummaryPanel(noticeId: studyId),
            Design.padding15,

            //
            TitleWidget(title: "MEMBER", icon: AppIcons.add,
              onTap: () => null,),
            _participantImages(),
            Design.padding15,

            //
            TitleWidget(title: "RULE", icon: AppIcons.edit,
                onTap: ()=> null,),
            RuleWidget(studyId: studyId),
            Design.padding15,

            TitleWidget(title: "ROUND LIST", icon: AppIcons.add, onTap: _addRound),
            RoundInfoListWidget(key: _roundInformationListKey, studyId: studyId),
          ],
        )
      )
    );
  }

  void _addRound() {
    _roundInformationListKey.currentState!.addNewRound();
  }

  Widget _participantImages() {
    return FutureBuilder(
      future: userList,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<CircleButton> userImages = snapshot.data!.map((e) =>
              CircleButton(child: null, onTap: () => UserProfileDialog.showProfileDialog(context, e.userId),
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