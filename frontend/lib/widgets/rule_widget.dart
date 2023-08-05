
import 'package:flutter/material.dart';

class RuleWidget extends StatefulWidget {
  int studyId;
  RuleWidget({
    super.key,
    required this.studyId,
  });

  @override
  State<RuleWidget> createState() => _RuleWidget();
}

class _RuleWidget extends State<RuleWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text("Asd\n"),
        ],
      ),
    );
  }
}