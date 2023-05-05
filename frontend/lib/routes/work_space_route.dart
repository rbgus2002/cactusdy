import 'package:flutter/material.dart';

import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/widgets/circle_button.dart';
import 'package:group_study_app/widgets/panels/user_line_profile.dart';

class WorkSpaceRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _WorkSpaceRoute();
  }
}

class _WorkSpaceRoute extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                OutlineCircleButton(scale: 100.0, image: null, percent: 0.70, onTap: Test.onTabTest),
                UserLineProfile(scale: 50.0, image: null, onTap: Test.onTabTest, nickName: "NickName", comment: "Comment!",),

                // 좌우 스크롤
                // TODO : 별도 class로 분리
                Container(
                  margin: EdgeInsets.symmetric(vertical: 20.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                        CircleButton(scale: 65.0, image: null, onTap: Test.onTabTest),
                      ],
                    ),
                  ),
                ),


              ],
            )
          )
        )
    );
  }
}