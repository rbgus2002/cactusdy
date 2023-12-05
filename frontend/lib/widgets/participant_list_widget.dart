import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_summary.dart';
import 'package:group_study_app/routes/profiles/profile_route.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';

class ParticipantListWidget extends StatelessWidget {
  final List<ParticipantSummary> roundParticipantSummaries;
  final int studyId;
  final double size;

  const ParticipantListWidget({
    Key? key,
    required this.roundParticipantSummaries,
    required this.studyId,
    this.size = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,

      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        separatorBuilder: (context, index) => Design.padding8,
        itemCount: roundParticipantSummaries.length,
        itemBuilder: _builder,),
    );
  }

  Widget _builder(BuildContext context, int index) {
    return InkWell(
        onTap: () => Util.pushRouteWithSlideDown(context, (context, animation, secondaryAnimation) =>
          ProfileRoute(
              userId: roundParticipantSummaries[index].userId,
              studyId: studyId),),
        child: SquircleImageWidget(
          scale: size,
          url: roundParticipantSummaries[index].picture),
    );
  }
}