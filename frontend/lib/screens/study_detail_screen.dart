import 'package:flutter/material.dart';

class StudyDetailScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _StudyDetailScreen();
  }
}

class _StudyDetailScreen extends State<StatefulWidget> {
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