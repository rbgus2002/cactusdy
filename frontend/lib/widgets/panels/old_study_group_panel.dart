import 'package:flutter/material.dart';
import 'package:group_study_app/models/study_Info.dart';
import 'package:group_study_app/routes/studies/study_detail_route.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/old_circle_button.dart';
import 'package:group_study_app/widgets/buttons/outline_circle_button.dart';
import 'package:group_study_app/widgets/circle_button_list.dart';
import 'package:group_study_app/widgets/line_profiles/old_study_line_profile_widget.dart';
import 'package:group_study_app/widgets/panels/old_panel.dart';
import 'package:group_study_app/widgets/old_round_info_widget.dart';

class OldStudyGroupPanel extends StatelessWidget {
  final StudyInfo studyInfo;

  const OldStudyGroupPanel({
    Key? key,
    required this.studyInfo,
  }) : super(key: key) ;

  @override
  Widget build(BuildContext context) {
    List<OldCircleButton> userImages = studyInfo.profileImages.map((participant) =>
        OutlineCircleButton(scale: 24, url: participant, stroke: 2,),).toList();
    return OldPanel(
        boxShadows: OldDesign.basicShadows,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            OldStudyLineProfileWidget(study: studyInfo.study,
                bottomWidget: CircleButtonList(
                  circleButtons: userImages,
                  paddingVertical: 2,
                )),
            OldDesign.padding10,

            OldRoundInfoWidget(roundSeq: studyInfo.roundSeq, round: studyInfo.round, studyId: studyInfo.study.studyId,),
            OldDesign.padding5,

            // task groups
            ListView.builder(
              shrinkWrap: true,
              primary: false,
              itemCount: studyInfo.taskGroups.length,
              itemBuilder: (context, index) => 
                Container(
                  padding: OldDesign.bottom10,
                  child: null,),
            )
          ],
        ),
        onTap: () { Util.pushRoute(context, (context) =>
            StudyDetailRoute(
              study: studyInfo.study,
            )); },
    );
  }
}