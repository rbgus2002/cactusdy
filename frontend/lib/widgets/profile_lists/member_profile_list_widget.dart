import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/studies/study_inviting_route.dart';
import 'package:groupstudy/routes/profiles/profile_route.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/squircle_widget.dart';

/// Study Member Profile List (All member of Study)
/// it shows images and nicknames
class MemberProfileListWidget extends StatelessWidget {
  final String studyName;
  final int studyId;
  final int hostId;
  final double scale;
  final Function(ParticipantProfile)? onTap;
  final double paddingSize;
  final bool border;

  const MemberProfileListWidget({
    Key? key,
    required this.studyName,
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
            height: scale + 12, // 12 = (padding: 2) + (nicknameHeight: 10);
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length + 1, // add 1 for last add button
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

  Widget _userProfile(BuildContext context, ParticipantProfile participantSummary) {
    bool host = _isHost(participantSummary.userId);

    return Stack(
        clipBehavior: Clip.none,
        children: [
          SizedBox(
            width: scale + paddingSize,
            child: InkWell(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Column(
                children: [
                  SquircleImageWidget(
                      scale: scale,
                      side: (border)?
                          BorderSide(
                            width: 3,
                            color: (host)?
                              ColorStyles.mainColor :
                              context.extraColors.grey500!) : null,
                      url: participantSummary.picture),
                  Design.padding(2),

                  Text(
                    participantSummary.nickname,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.body5.copyWith(
                        color: context.extraColors.grey700),),
                ],
              ),
              onTap: () {
                if (onTap != null) {
                  onTap!(participantSummary);
                } else {
                  // View Profile
                  Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
                      ProfileRoute(
                          userId: participantSummary.userId,
                          studyId: studyId));
                }
              },),
          ),

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
    return SizedBox(
      width: scale + paddingSize,
      child: Column(
        children: [
          InkWell(
            highlightColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: SquircleWidget(
              scale: scale,
              backgroundColor:Colors.transparent,
              child: Icon(
                  size: 24,
                  Icons.add,
                  color: context.extraColors.grey400,),),
            onTap: () {
              HapticFeedback.lightImpact();
              Util.pushRoute(context, (context) =>
                  StudyInvitingRoute(
                    studyName: studyName,
                    studyId: studyId,));
            }),
        ],
      ),
    );
  }

  Widget _adminBadge(BuildContext context) {
    return Positioned(
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