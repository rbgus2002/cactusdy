import 'package:flutter/material.dart';
import 'package:group_study_app/models/sign_info.dart';
import 'package:group_study_app/models/task.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/widgets/image_picker_widget.dart';
import 'package:group_study_app/widgets/panels/panel.dart';

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
            padding: Design.edge15,
            child: const ImagePickerWidget(),
        )
    );
  }
}