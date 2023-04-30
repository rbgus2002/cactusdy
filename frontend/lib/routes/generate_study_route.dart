import 'package:flutter/material.dart';
import 'package:group_study_app/widgets/circle_button.dart';

class GenerateStudyRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GenerateStudyRoute();
  }
}

class _GenerateStudyRoute extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: CircleButton(scale: 100, image: null, onTap: onTabTest),
        )
    );
  }

  void onTabTest() {
    print('Tab!');
  }
}