import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_summary.dart';
import 'package:group_study_app/routes/user_profile_route.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';

class MemberProfileListWidget extends StatelessWidget {
  final int studyId;
  final double scale;

  const MemberProfileListWidget({
    Key? key,
    required this.studyId,
    this.scale = 40.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ParticipantSummary.getParticipantsProfileImageList(studyId),
      builder: (context, snapshot) =>
        (snapshot.hasData) ?
          SizedBox(
            height: scale,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data!.length + 1, // add 1 for last add button
              separatorBuilder: (context, index) => Design.padding8,
              itemBuilder: (context, index) =>
                _isLast(index, snapshot.data!.length) ?
                    // last => Add Participant Button
                    _addButton(context) :
                    // else => User Profile
                    Stack(
                      clipBehavior: Clip.none,
                      children: [
                        InkWell(
                          borderRadius: BorderRadius.circular(scale / 2),
                          child: SquircleImageWidget(
                            scale: scale,
                            url: snapshot.data![index].picture),
                          onTap: () => Util.pushRouteWithSlideDown(context, (context, animation, secondaryAnimation) =>
                            UserProfileRoute(
                              userId: snapshot.data![index].userId,
                              studyId: studyId),),),

                        if (index == 0)
                          _adminBadge(),
                      ],),
                    ),
          ) : SizedBox(height: scale,),
    );
  }

  bool _isLast(int index, int length) {
    return (index == length);
  }

  Widget _addButton(BuildContext context) {
    return InkWell(
      child: SquircleWidget(
        scale: scale,
        backgroundColor:Colors.transparent,
        child: Icon(
            size: 24,
            Icons.add,
            color: context.extraColors.grey400,),),
      onTap: () {});
  }

  Widget _adminBadge() {
    return Positioned(
        left: -4,
        top: 24,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: Design.basicShadows,),
          child: Image.asset(
            'assets/images/crown.png',
            height: 18,
            width: 18,),),
    );
  }
}