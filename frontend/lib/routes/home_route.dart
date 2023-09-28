import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/generate_study_route.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/panels/study_group_panel.dart';
import 'package:group_study_app/widgets/line_profiles/user_line_profile_widget.dart';

class HomeRoute extends StatefulWidget {
  final int userId = Test.testUser.userId;

  HomeRoute({super.key});

  @override
  State<HomeRoute> createState() {
    return _HomeRoute();
  }
}

class _HomeRoute extends State<HomeRoute> {
  late Future<User> user;

  @override
  void initState() {
    super.initState();
    user = User.getUserProfileSummary(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Design.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder(
              future: user,
              builder: (context, snapshot) {

                if (snapshot.hasData) {
                  return UserLineProfileWidget(user: snapshot.data!);
                }
                else
                  return Container();
              }
            ),

            Design.padding10,
            StudyGroupPanel(studyId: 1,),
            StudyGroupPanel(studyId: 1,),
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