import 'package:flutter/material.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/round_info.dart';
import 'package:group_study_app/widgets/user_list_button.dart';

import '../../models/user.dart';
import '../../themes/design.dart';
import '../../themes/text_styles.dart';
import '../../utilities/test.dart';
import 'dart:math' as math;

class RoundInfoPanel extends StatelessWidget {
  final int roundIdx;
  final String? place;
  final DateTime? date;
  final List<User> userList;

  final onTap;

  const RoundInfoPanel({
    Key? key,
    required this.roundIdx,
    this.place,
    this.date,
    required this.userList,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Panel(
        backgroundColor: Colors.white,
        boxShadows: Design.basicShadows,
        padding: 10,
        child: Column(
          children: [
            Row(
              children: [
                RoundInfo(
                  roundIdx: roundIdx,
                  place: place,
                  date: date,
                ),
                Transform(
                  alignment: Alignment.centerRight,
                  transform: Matrix4.rotationY(math.pi),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.arrow_back_ios_new_rounded),
                    color: Colors.black87,
                    iconSize: 35,
                  ),
                )
              ],
            ),
            UserList(
                userList:
                    List<User>.generate(30, (index) => User(index, "d", "d")),
                onTap: Test.onTabTest),
          ],
        ));
  }
}
