

import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/studies/study_create_page3.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';

class StudyInvitingRoute extends StatefulWidget {
  final int studyId;

  const StudyInvitingRoute({
    Key? key,
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
                  StudyCreatePage3(inviteCode: snapshot.data!) :
                  const SizedBox(),),
          ],),),
    );
  }
}
