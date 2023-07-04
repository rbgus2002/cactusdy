import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/panels/study_group_panel.dart';
import 'package:group_study_app/widgets/user_line_profile.dart';

class HomeRoute extends StatefulWidget {
  final int userId = Test.testUser.userId;

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
            Design.padding15,
            Design.padding15,
            Design.padding15,
            FutureBuilder(
              future: user,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return UserLineProfile(user: snapshot.data!);
                }
                else
                  return Container();
              }
            ),
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