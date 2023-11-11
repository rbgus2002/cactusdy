import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/line_profiles/user_line_profile_widget.dart';
import 'package:image_picker/image_picker.dart';

class TestRouteState extends StatefulWidget {
  const TestRouteState({
    Key? key,
  }) : super(key: key);

  @override
  State<TestRouteState> createState() => _TestRoute();
}

class _TestRoute extends State<TestRouteState> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("ASD")),
        body: Container(
          margin: EdgeInsets.all(20),
          decoration: BoxDecoration(
            border: Border.all(color: context.extraColors.grey200!, width: 2),
          ),
          child: UserLineProfileWidget(user: User(statusMessage: "Additional Comment", userId: 2, nickname: "채령", picture: ""),),
            padding: OldDesign.edge15,
        )
    );
  }

  void uploadProfileImage(XFile profileImage) async {
    await User.updateProfileImage(profileImage);
  }
}