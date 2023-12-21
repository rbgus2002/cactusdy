

import 'package:flutter/material.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/studies/study_create_page3.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';

class StudyInvitingRoute extends StatefulWidget {
  final String studyName;
  final int studyId;

  const StudyInvitingRoute({
    Key? key,
    required this.studyName,
    required this.studyId,
  }) : super(key: key);

  @override
  State<StudyInvitingRoute> createState() => _StudyInvitingRouteState();
}

class _StudyInvitingRouteState extends State<StudyInvitingRoute> {
  final int invitingCode = 866990;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: Design.edgePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Design.padding4,

            Text(
              context.local.startStudyWithFriend,
              style: TextStyles.head2.copyWith(
                color: context.extraColors.grey800,),),

            FutureBuilder(
              future: Study.getStudyInvitingCode(widget.studyId),
              builder: (context, snapshot) =>
                (snapshot.hasData)?
                  StudyCreatePage3(
                      studyName: widget.studyName,
                      invitingCode: snapshot.data!) :
                  const SizedBox(),),
          ],),),
    );
  }
}
