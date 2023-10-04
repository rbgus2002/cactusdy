import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/models/study_Info.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/generate_study_route.dart';
import 'package:group_study_app/routes/sign_in_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/panels/study_group_panel.dart';
import 'package:group_study_app/widgets/line_profiles/user_line_profile_widget.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({
    Key? key
  }) : super(key: key);

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Design.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: User.getUserProfileSummary(),
              builder: (context, snapshot) {

                if (snapshot.hasData) {
                  return UserLineProfileWidget(user: snapshot.data!);
                }
                else {
                  return Container(); //< FIXME
                }
              }
            ),

            Design.padding10,
            FutureBuilder(
              future: StudyInfo.getStudies(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<StudyInfo> studyInfos = snapshot.data!;
                  return ListView.builder(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: studyInfos.length,
                      itemBuilder: (context, index) =>
                        StudyGroupPanel(studyInfo: studyInfos[index]),
                  );
                }
                return Design.loadingIndicator;
              },
            ),
            //StudyGroupPanel(studyId: 1,),
            //StudyGroupPanel(studyId: 1,),
            //StudyGroupPanel(),

            addStudyPanel(),
          ],
        ),
      ),
    );
  }

  Widget addStudyPanel() {
    return Panel(
      backgroundColor: ColorStyles.lightGrey,
      boxShadows: Design.basicShadows,
      onTap: () => Util.pushRoute(context, (context) => GenerateStudyRoute()),
      child: const Center(
        child: AppIcons.add,
      ),
    );
  }
}