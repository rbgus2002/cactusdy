import 'package:flutter/material.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/widgets/panels/study_group_panel.dart';
import 'package:group_study_app/widgets/user_line_profile.dart';

class HomeRoute extends StatefulWidget {
  @override
  State<HomeRoute> createState() {
    return _HomeRoute();
  }
}

class _HomeRoute extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Design.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Design.padding15,
            Design.padding15,
            Design.padding15,
            UserLineProfile(nickName: "nickName", comment: "comment"),
            Design.padding10,
            StudyGroupPanel(),
            StudyGroupPanel(),
            StudyGroupPanel(),
          ],
        ),
      ),
    );
  }
}