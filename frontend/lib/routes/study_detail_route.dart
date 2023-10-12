import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_summary.dart';
import 'package:group_study_app/models/round.dart';
import 'package:group_study_app/models/sign_info.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/notice_list_route.dart';
import 'package:group_study_app/services/auth.dart';
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
import 'package:group_study_app/widgets/participant_profile_list_widget.dart';
import 'package:group_study_app/widgets/round_info_list_widget.dart';
import 'package:group_study_app/widgets/rule_widget.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class StudyDetailRoute extends StatelessWidget {
  final GlobalKey<RoundInfoListWidgetState> _roundInformationListKey = GlobalKey<RoundInfoListWidgetState>();
  late ListModel<Round> _roundList;

  final int studyId;

  StudyDetailRoute({
    Key? key,
    required this.studyId,
  }) : super(key: key);

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
            FutureBuilder(
                future: Study.getStudySummary(studyId),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return StudyLineProfileWidget(study: snapshot.data!);
                  }
                  return const SizedBox(); //< FIXME
              },),
            Design.padding15,

            // Notice
            TitleWidget(title: "NOTICE", icon: AppIcons.chevronRight,
              onTap: () => Util.pushRoute(context, (context)=>NoticeListRoute(studyId: studyId,))),
            NoticeSummaryPanel(studyId: studyId,),
            Design.padding15,

            //
            TitleWidget(title: "MEMBER", icon: AppIcons.add,
              onTap: () => null,),
            ParticipantProfileListWidget(studyId: studyId),
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
}