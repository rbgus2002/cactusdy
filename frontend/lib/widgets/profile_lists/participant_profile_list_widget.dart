import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/profiles/profile_route.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';

/// Round Participant Profile List (not all member of study)
/// Tap Profile => View Profile
class ParticipantProfileListWidget extends StatelessWidget {
  final List<ParticipantSummary> roundParticipantSummaries;
  final int studyId;
  final double size;

  const ParticipantProfileListWidget({
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
        itemBuilder: _profileImageBuilder,),
    );
  }

  Widget _profileImageBuilder(BuildContext context, int index) {
    return InkWell(
        onTap: () => _viewProfile(context, index),
        child: SquircleImageWidget(
          scale: size,
          url: roundParticipantSummaries[index].picture),
    );
  }

  void _viewProfile(BuildContext context, int index) {
    Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
      ProfileRoute(
          userId: roundParticipantSummaries[index].userId,
          studyId: studyId),);
  }
}