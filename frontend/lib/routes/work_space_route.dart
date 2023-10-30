import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/old_color_styles.dart';
import 'package:group_study_app/themes/old_design.dart';

import 'package:group_study_app/widgets/Tags/user_state_tag.dart';
import 'package:group_study_app/widgets/buttons/percent_circle_button.dart';
import 'package:group_study_app/widgets/charts/bar_chart.dart';
import 'package:group_study_app/widgets/charts/chart.dart';
import 'package:group_study_app/widgets/dialogs/user_profile_dialog.dart';
import 'package:group_study_app/widgets/image_picker_widget.dart';
import 'package:group_study_app/widgets/panels/notice_panel.dart';
import 'package:group_study_app/widgets/panels/panel.dart';
import 'package:group_study_app/widgets/tags/study_group_tag.dart';
import 'package:image_picker/image_picker.dart';

class WorkSpaceRouteState extends StatefulWidget {
  const WorkSpaceRouteState({
    Key? key
  }) : super(key: key);

  @override
  State<WorkSpaceRouteState> createState() => _WorkSpaceRoute();
}

class _WorkSpaceRoute extends State<WorkSpaceRouteState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                ImagePickerWidget(onPicked: uploadProfileImage),
              ],
            )
          )
        )
    );
  }

  void uploadProfileImage(XFile profileImage) async {
    await User.updateProfileImage(profileImage);
  }
}