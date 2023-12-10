import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/studies/study_inviting_route.dart';
import 'package:group_study_app/routes/profiles/profile_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';

/// Study Member Profile List
class MemberProfileListWidget extends StatelessWidget {
  final int studyId;
  final int hostId;
  final double scale;
  final Function(ParticipantSummary)? onTap;
  final double paddingSize;
  final bool border;

  const MemberProfileListWidget({
    Key? key,
    required this.studyId,
    required this.hostId,
    this.scale = 40.0,
    this.paddingSize = 8,
    this.onTap,
    this.border = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Study.getMemberProfileImages(studyId),
      builder: (context, snapshot) =>
        (snapshot.hasData) ?
          SizedBox(
            height: scale,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length + 1, // add 1 for last add button
              separatorBuilder: (context, index) => Design.padding(paddingSize),
              itemBuilder: (context, index) =>
                _isLast(index, snapshot.data!.length) ?
                    // last => Add Participant Button
                    _addButton(context) :
                    // else => User Profile
                    _userProfile(context, snapshot.data![index]),
            ),) :
          SizedBox(height: scale,),
    );
  }

  Widget _userProfile(BuildContext context, ParticipantSummary participantSummary) {
    bool host = _isHost(participantSummary.userId);

    return Stack(
        clipBehavior: Clip.none,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(scale / 2),
            child: SquircleImageWidget(
                scale: scale,
                side: (border)?
                    BorderSide(
                      width: 3,
                      color: (host)?
                        ColorStyles.mainColor :
                        context.extraColors.grey500!) : null,
                url: participantSummary.picture),
            onTap: () {
              if (onTap != null) {
                onTap!(participantSummary);
              } else {
                // View Profile
                Util.pushRouteWithSlideDown(context, (context, animation, secondaryAnimation) =>
                    ProfileRoute(
                        userId: participantSummary.userId,
                        studyId: studyId));
              }
            },),

          if (host)
            _adminBadge(context),
        ],
    );
  }

  bool _isHost(int userId) {
    return userId == hostId;
  }

  bool _isLast(int index, int length) {
    return (index == length);
  }

  Widget _addButton(BuildContext context) {
    return InkWell(
      highlightColor: Colors.transparent,
      splashColor: Colors.transparent,
      child: SquircleWidget(
        scale: scale,
        backgroundColor:Colors.transparent,
        child: Icon(
            size: 24,
            Icons.add,
            color: context.extraColors.grey400,),),
      onTap: () => Util.pushRoute(context, (context) =>
          StudyInvitingRoute(studyId: studyId,)));
  }

  Widget _adminBadge(BuildContext context) {
    return Positioned(
        left: -4,
        top: 24,
        child: CircleAvatar(
          radius: 9,
          backgroundColor: context.extraColors.grey000,
            child: Image.asset(
              'assets/images/crown.png',
              height: 16,
              width: 16,),
          ),
    );
  }
}