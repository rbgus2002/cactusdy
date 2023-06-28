import 'package:flutter/material.dart';

class GenerateStudyRoute extends StatefulWidget {
  @override
  State<GenerateStudyRoute> createState() {
    return _GenerateStudyRoute();
  }
}

class _GenerateStudyRoute extends State<GenerateStudyRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,),
      body: Center(
        child: Text(
          'Home Screen',
        )
      )
    );
  }
}