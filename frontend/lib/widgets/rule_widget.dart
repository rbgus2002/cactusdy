
import 'package:flutter/material.dart';
import 'package:group_study_app/themes/old_app_icons.dart';
import 'package:group_study_app/widgets/title_widget.dart';

class RuleListWidget extends StatefulWidget {
  int studyId;

  RuleListWidget({
    Key? key,
    required this.studyId,
  }) : super(key: key);

  @override
  State<RuleListWidget> createState() => _RuleListWidgetState();
}

class _RuleListWidgetState extends State<RuleListWidget> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleWidget(title: "RULE", icon: OldAppIcons.edit,
            onTap: ()=> null,),
          Text("Asd\n"),
        ],
      ),
    );
  }
}