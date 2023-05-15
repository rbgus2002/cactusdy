import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/widgets/panels/study_group_panel.dart';
import 'package:group_study_app/widgets/user_line_profile.dart';

class HomeRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeRoute();
  }
}

class _HomeRoute extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(Design.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            UserLineProfile(nickName: "nickName", comment: "comment"),
            Design.padding10,
            StudyGroupPanel(),
            Design.padding10,
            StudyGroupPanel(),
          ],
        ),
      ),
    );
  }
}