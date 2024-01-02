import 'package:flutter/material.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/routes/profiles/profile_route.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/squircle_widget.dart';

/// Round Participant Profile List (not all member of study)
/// Tap Profile => View Profile
class ParticipantProfileListWidget extends StatelessWidget {
  final List<UserProfileSummary> roundParticipantSummaries;
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
        separatorBuilder: (context, index) => Design.padding4,
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