
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_profile.dart';
import 'package:group_study_app/models/study_tag.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';
import 'package:group_study_app/widgets/tags/study_tag_widget.dart';

class UserProfileRoute extends StatefulWidget {
  final int userId;
  final int studyId;

  const UserProfileRoute({
    Key? key,
    required this.userId,
    required this.studyId,
  }) : super(key: key);

  @override
  State<UserProfileRoute> createState() => _UserProfileRouteState();
}

class _UserProfileRouteState extends State<UserProfileRoute> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shape: InputBorder.none,),
      body: FutureBuilder(
          future: ParticipantProfile.getParticipantProfile(widget.userId, widget.studyId),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                  children: [
                    Design.padding4,

                    _userProfileBox(snapshot.data!.participant),
                    _studyListBox(snapshot.data!.studyTags),
                    _attendanceRateBox(),
                    _taskAchievementRate(),
                  ],
              );
            }
            return Design.loadingIndicator;
          }
      ),
    );
  }

  Widget _userProfileBox(User participant) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: context.extraColors.grey100!,
          width: 4,),),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SquircleWidget(
            scale: 100,
            child: (participant.profileImage.isNotEmpty) ?
              CachedNetworkImage(
                  imageUrl: participant.profileImage,
                  fit: BoxFit.cover) : null,),
          Design.padding20,

          Text(
            participant.nickname,
            style: TextStyles.head2.copyWith(color:
            context.extraColors.grey800),),
          Design.padding4,

          Text(
            (participant.statusMessage.isEmpty) ?
                participant.statusMessage :
                context.local.inputHint2(context.local.statusMessage),
            style: TextStyles.body1.copyWith(color:
              context.extraColors.grey500),),
          Design.padding32,
        ],),
    );
  }

  Widget _studyListBox(List<StudyTag> studyTags) {
    return Container(
      padding: Design.edgePadding,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: context.extraColors.grey200!,),),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Design.padding(20),

          Text(
            context.local.joinedStudy,
            style: TextStyles.head3.copyWith(
                color: context.extraColors.grey800),),
          Design.padding16,

          Wrap(
            runSpacing: 8,
            spacing: 8,
            children: [
              for (StudyTag studyTag in studyTags)
                StudyTagWidget(studyTag: studyTag),
            ]),
          Design.padding16,
        ],),
    );
  }

  Widget _attendanceRateBox() {
    return Container(
      padding: Design.edgePadding,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: context.extraColors.grey200!,),),),
      child: Column(
        children: [
          Text(
            context.local.attendanceRate,
            style: TextStyles.head3.copyWith(
                color: context.extraColors.grey800),),
          Design.padding16,


        ],
      ),
    );
  }

  Widget _taskAchievementRate() {
    return Container();
  }
}