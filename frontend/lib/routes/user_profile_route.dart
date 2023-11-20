
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/participant_profile.dart';
import 'package:group_study_app/models/status_tag.dart';
import 'package:group_study_app/models/study_tag.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/buttons/outlined_primary_button.dart';
import 'package:group_study_app/widgets/buttons/primary_button.dart';
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
                    _attendanceRateBox(snapshot.data!.attendanceRate),
                    _taskAchievementRate(snapshot.data!.doneRate),
                    _kickAndStabButtons(),
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

  Widget _attendanceRateBox(Map<String, int> attendanceRate) {
    return Container(
      padding: Design.edgePadding,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: context.extraColors.grey200!,),),),
      child: Column(
        children: [
          Design.padding8,

          Text(
            context.local.attendanceRate,
            style: TextStyles.head3.copyWith(
                color: context.extraColors.grey800),),
          Design.padding16,

          _AttendanceRateWidget(
            attendanceCount: attendanceRate[StatusTag.attendance]??0,
            lateCount: attendanceRate[StatusTag.late]??0,
            absentCount: attendanceRate[StatusTag.absent]??0,),
          Design.padding(36),
          
          _AttendanceWidget(
              status: StatusTag.attendance,
              count: attendanceRate[StatusTag.attendance]??0),
          Design.padding32,

          _AttendanceWidget(
              status: StatusTag.late,
              count: attendanceRate[StatusTag.late]??0),
          Design.padding32,

          _AttendanceWidget(
              status: StatusTag.absent,
              count: attendanceRate[StatusTag.absent]??0),
          Design.padding24,
        ],
      ),
    );
  }

  Widget _taskAchievementRate(int rate) {
    return Container(
      padding: Design.edgePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Design.padding8,

          Text(
            context.local.taskAchievementRateIs(rate),
            style: TextStyles.head3.copyWith(
              color: context.extraColors.grey800,),),
          Design.padding28,

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _AchievementBarWidget(
                percent: rate,
                color: ColorStyles.mainColor,
                headTag: context.local.achievement),
              Design.padding(52),

              _AchievementBarWidget(
                percent: 100 - rate,
                color: context.extraColors.grey100!,
                textColor: context.extraColors.grey500!,),
              Design.padding4,
            ],),
      ],),
    );
  }

  Widget _kickAndStabButtons() {
    return Container(
      padding: Design.edgePadding,
      height: 92,
      child: Row(
        children: [
          OutlinedPrimaryButton(
              text: context.local.kick,
          width: 100,),
          Design.padding4,

          _primaryButtonWithIcon(
              text: context.local.stab,
              icon: Icon(CustomIcons.cactus,),
              onTap: () { }),
        ],

      ),
    );
  }

  Widget _primaryButtonWithIcon({
    required String text,
    required Icon icon,
    required VoidCallback onTap}) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
          disabledBackgroundColor: context.extraColors.disabledPrimaryButtonColor,
          disabledForegroundColor: context.extraColors.grey000),
      child: Container(
        height: Design.buttonContentHeight,
        alignment: Alignment.center,
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Design.padding4,
              Text(
                text,
                style: TextStyles.head4,),
            ],),
      ),
    );
  }
}

class _AttendanceWidget extends StatelessWidget {
  static const double _height = 24;

  final String status;
  final int count;

  const _AttendanceWidget({
    Key? key,
    required this.status,
    required this.count,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: _height,
          height: _height,
          decoration: BoxDecoration(
            color: StatusTag.getColor(status, context),
            shape: BoxShape.circle,),),
        Design.padding12,

        Expanded(
          child: Text(
            StatusTag.getText(status, context),
            style: TextStyles.head4.copyWith(
              color: context.extraColors.grey900,),),),

        Text(
          '$count${context.local.count}',
          style: TextStyles.body1.copyWith(
            color: context.extraColors.grey600,),),
      ],
    );
  }
}

class _AchievementBarWidget extends StatelessWidget {
  final Color color;
  final Color? textColor;
  final int percent;
  final String headTag;

  const _AchievementBarWidget({
    Key? key,
    required this.color,
    required this.percent,
    this.textColor,
    this.headTag = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 76,
      height: 200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Visibility(
            visible: (headTag.isNotEmpty),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: color.withOpacity(0.2),),
              child: Text(
                headTag,
                style: TextStyles.head5.copyWith(
                    color: textColor??color),),),),
          Design.padding12,

          Container(
            width: 76,
            height: 1.2 * percent, // MAX_HEIGHT : 120
            decoration: BoxDecoration(
              color: color,
              borderRadius: Design.borderRadius,),),
          Design.padding8,

          Text(
            "$percent%",
            style: TextStyles.head3.copyWith(
              color: textColor??color,),),
        ],
      ),
    );
  }
}

class _AttendanceRateWidget extends StatelessWidget {
  static const double _height = 30;

  final int attendanceCount;
  final int lateCount;
  final int absentCount;

  const _AttendanceRateWidget({
    Key? key,
    required this.attendanceCount,
    required this.lateCount,
    required this.absentCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: _height,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
          color: (isEmpty())? context.extraColors.grey100! : null,
          borderRadius: Design.borderRadiusSmall),
      child: Row(
        children: [
          Flexible(
            flex: attendanceCount,
            child: Container(
              color: StatusTag.getColor(StatusTag.attendance, context),),),

          Visibility(
            visible: (attendanceCount * lateCount != 0),
            child: Design.padding4,),

          Flexible(
            flex: lateCount,
            child: Container(
              color: StatusTag.getColor(StatusTag.late, context),),),

          Visibility(
            visible: (lateCount * absentCount != 0 || attendanceCount * absentCount != 0),
            child: Design.padding4,),

          Flexible(
            flex: absentCount,
            child: Container(
              color: StatusTag.getColor(StatusTag.absent, context),),),
        ],
      ),
    );
  }

  bool isEmpty() {
    return (attendanceCount + absentCount + lateCount <= 0);
  }
}