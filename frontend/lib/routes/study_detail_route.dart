import 'package:flutter/material.dart';

class StudyDetailRoute extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StudyDetailRoute();
  }
}

class _StudyDetailRoute extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
              'Study Detail Screen',
            )
        )
    );
  }
}