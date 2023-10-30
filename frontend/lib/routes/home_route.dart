import 'package:flutter/material.dart';
import 'package:group_study_app/models/study_Info.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/generate_study_route.dart';
import 'package:group_study_app/routes/start_route.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/old_app_icons.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/themes/old_text_styles.dart';
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
  static const String _signOutCautionMessage = "로그아웃 하시겠어요?"; // < FIXME 뭔가 별로
  static const String _signOutText = "로그아웃";

  static const String _checkText = "확인";
  static const String _cancelText = "취소";

  late final Future<User> _futureUser;

  @override
  void initState() {
    super.initState();
    _futureUser = User.getUserProfileSummary();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          actions: [
            _homePopupMenu(),
          ]),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(OldDesign.padding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FutureBuilder(
                future: _futureUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return UserLineProfileWidget(user: snapshot.data!);
                  }
                  else {
                    return Container(); //< FIXME
                  }
                }
              ),

              OldDesign.padding10,
              FutureBuilder(
                future: StudyInfo.getStudies(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) =>
                          StudyGroupPanel(studyInfo: snapshot.data![index]),
                    );
                  }
                  return OldDesign.loadingIndicator;
                },
              ),

              addStudyPanel(),
            ],
          ),
        ),
      ),
    );
  }

  Widget addStudyPanel() {
    return Panel(
      backgroundColor: OldColorStyles.lightGrey,
      boxShadows: OldDesign.basicShadows,
      onTap: () => Util.pushRoute(context, (context) => const GenerateStudyRoute()),
      child: const Center(
        child: OldAppIcons.add,
      ),
    );
  }

  // FIXME : this is temporary
  Widget _homePopupMenu() {
    return PopupMenuButton(
        icon: OldAppIcons.moreVert,
        splashRadius: 16,
        offset: const Offset(0, 42),

        itemBuilder: (context) => [
          PopupMenuItem(
              child: const Text(_signOutText, style: OldTextStyles.bodyMedium),
              onTap: () => _showSignOutDialog(context),),
        ]
    );
  }

  void _showSignOutDialog(BuildContext context) {
    Future.delayed(Duration.zero, () => showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          content: const Text(_signOutCautionMessage),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(_cancelText),),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Auth.signOut();
                Future.delayed(Duration.zero, () {
                  Util.pushRouteAndPopUtil(context, (context) => const StartRoute());
                });
              },
              child: const Text(_checkText),)
          ],
        ))
    );
  }
}