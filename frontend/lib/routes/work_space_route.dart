import 'package:flutter/material.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/widgets/image_picker_widget.dart';
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