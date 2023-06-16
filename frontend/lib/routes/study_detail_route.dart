import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/NoticeListWidget.dart';
import 'package:group_study_app/widgets/buttons/outline_circle_button.dart';
import 'package:group_study_app/widgets/buttons/percent_circle_button.dart';
import 'package:group_study_app/widgets/panels/round_info_panel.dart';
import 'package:group_study_app/widgets/title_widget.dart';
import 'package:group_study_app/widgets/user_list_button.dart';

class StudyDetailRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StudyDetailRoute();
  }
}

class _StudyDetailRoute extends State<StatefulWidget> {
  List<User> userList = List<User>.generate(30, (index) => User(index, "d", "d"));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(Design.padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            NoticeListWidget(),
            Design.padding15,

            //
            const TitleWidget(title: "MEMBER", icon: Icon(Icons.add)),
            UserListButton(userList: userList, scale: 45, ),
            Design.padding15,

            //
            const TitleWidget(title: "RULE", icon: Icon(Icons.edit)),
            Design.padding15,

            const TitleWidget(title: "ROUND LIST", icon: Icon(Icons.add), onTap: Test.onTabTest),

            RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: [ User(0, "d", "d")]),
            RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: [ User(0, "d", "d")]),
            RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: [ User(0, "d", "d")]),
            RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: [ User(0, "d", "d")]),
            RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: [ User(0, "d", "d")]),
            RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: [ User(0, "d", "d")]),
            RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: [ User(0, "d", "d")]),
            RoundInfoPanel(roundIdx: 3, place: "asd", date: DateTime(2019, 3, 26), userList: [ User(0, "d", "d")]),

          ],
        ),
      )
    );
  }
}