import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/notice_list_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/panels/notice_list_panel.dart';
import 'package:group_study_app/widgets/buttons/outline_circle_button.dart';
import 'package:group_study_app/widgets/panels/round_info_panel.dart';
import 'package:group_study_app/widgets/title_widget.dart';
import 'package:group_study_app/widgets/user_list_button.dart';

class StudyDetailRoute extends StatefulWidget {
  @override
  State<StudyDetailRoute> createState() {
    return _StudyDetailRoute();
  }
}

class _StudyDetailRoute extends State<StudyDetailRoute> {
  List<User> userList = List<User>.generate(30, (index) => User(userId: 0, nickname: "d", statusMessage: "", picture: ""));

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
            Row(children : [
              OutlineCircleButton(image:null, scale: 60, stroke: 5, color: ColorStyles.red),
              Design.padding10,
              const Flexible(
                fit: FlexFit.tight,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text("STUDY GROUP NAME", style: TextStyles.titleLarge,),
                    Text("additional comment", style: TextStyles.bodyLarge, ),
                  ]
                )
              ),
              Icon(Icons.edit),
              ]),
            Design.padding15,

            // Notice
            TitleWidget(title: "NOTICE", icon: const Icon(Icons.chevron_right),
              onTap: () => Util.pushRoute(context, (context)=>NoticeListRoute())),
            NoticeListPanel(),
            Design.padding15,

            //
            TitleWidget(title: "MEMBER", icon: const Icon(Icons.add),),
            UserListButton(userList: userList, scale: 45, ),
            Design.padding15,

            //
            const TitleWidget(title: "RULE", icon: Icon(Icons.edit, size: 18,)),
            Design.padding15,

            const TitleWidget(title: "ROUND LIST", icon: Icon(Icons.add), onTap: Test.onTabTest),

            RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: Test.testUserList),
            RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: Test.testUserList),
            RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: Test.testUserList),

          ],
        ),
      )
    );
  }
}