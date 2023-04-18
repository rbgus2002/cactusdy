import 'package:flutter/material.dart';

class GenerateStudyScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _GenerateStudyScreen();
  }
}

class _GenerateStudyScreen extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Text(
              'Generate Study Screen',
            )
        )
    );
  }
}