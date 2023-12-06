
import 'package:flutter/material.dart';
import 'package:group_study_app/models/status_tag.dart';
import 'package:group_study_app/models/study_tag.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/services/auth.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/stab_controller.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/outlined_primary_button.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';
import 'package:group_study_app/widgets/tags/study_tag_widget.dart';

class ProfileRoute extends StatefulWidget {
  final int userId;
  final int studyId;

  const ProfileRoute({
    Key? key,
    required this.userId,
    required this.studyId,
  }) : super(key: key);

  @override
  State<ProfileRoute> createState() => _ProfileRouteState();
}

class _ProfileRouteState extends State<ProfileRoute> {
  static const double _profileImageSize = 100;
  late final UserStabController userStabController;

  @override
  void initState() {
    super.initState();
    userStabController = UserStabController(
        targetUserId: widget.userId,
        studyId: widget.studyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Close button
        leading: IconButton(
          icon: const Icon(CustomIcons.close),
          iconSize: 32,
          onPressed: () => Util.popRoute(context)),
        shape: InputBorder.none,),
      body: FutureBuilder(
          future: User.getUserProfile(widget.userId, widget.studyId),
          builder: (context, snapshot) =>
            (snapshot.hasData)?
              ListView(
                children: [
                  _userProfileWidget(snapshot.data!.user),
                  _studyListWidget(snapshot.data!.studyTags),
                  _attendanceRateWidget(snapshot.data!.attendanceRate),
                  _achievementRateWidget(snapshot.data!.doneRate),
                  _kickAndStabButton(),
                ],) :
              Design.loadingIndicator,),
    );
  }

  @override
  void dispose() {
    userStabController.send();
    super.dispose();
  }

  Widget _userProfileWidget(User participant) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: context.extraColors.grey100!,
          width: 4,),),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Design.padding4,

          SquircleImageWidget(
            scale: _profileImageSize,
            url: participant.profileImage),
          Design.padding20,

          Text(
            participant.nickname,
            style: TextStyles.head2.copyWith(
              color: context.extraColors.grey800),),
          Design.padding4,

          Text(
            (participant.statusMessage.isNotEmpty) ?
                participant.statusMessage :
                context.local.inputHint2(context.local.statusMessage),
            style: TextStyles.body1.copyWith(
              color: context.extraColors.grey500),),
          Design.padding32,
        ],),
    );
  }

  Widget _studyListWidget(List<StudyTag> studyTags) {
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

  Widget _attendanceRateWidget(Map<String, int> attendanceRate) {
    return Container(
      padding: Design.edgePadding,
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(
          color: context.extraColors.grey200!,),),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Design.padding8,

          Text(
            context.local.attendanceRate,
            style: TextStyles.head3.copyWith(
                color: context.extraColors.grey800),),
          Design.padding16,

          // Stacked Bar Chart
          _AttendanceRateChartWidget(
            attendanceCount: attendanceRate[StatusTag.attendanceCode]??0,
            lateCount: attendanceRate[StatusTag.lateCode]??0,
            absentCount: attendanceRate[StatusTag.absentCode]??0,),
          Design.padding(36),

          // Attendance
          _StatusSummaryWidget(
              status: StatusTag.attendance,
              count: attendanceRate[StatusTag.attendanceCode]??0),
          Design.padding32,

          // Late
          _StatusSummaryWidget(
              status: StatusTag.late,
              count: attendanceRate[StatusTag.lateCode]??0),
          Design.padding32,

          // Absent
          _StatusSummaryWidget(
              status: StatusTag.absent,
              count: attendanceRate[StatusTag.absentCode]??0),
          Design.padding24,
        ],
      ),
    );
  }

  Widget _achievementRateWidget(int rate) {
    return Container(
      padding: Design.edgePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Design.padding8,

          // Achievement Rate Text
          Text(
            context.local.taskAchievementRateIs(rate),
            style: TextStyles.head3.copyWith(
              color: context.extraColors.grey800,),),
          Design.padding28,

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Attendance Rate Graph
              _GraphBarWidget(
                percent: rate,
                color: ColorStyles.mainColor,
                headTag: context.local.achievement),
              Design.padding(52),

              // non-Attendance Rate Graph
              _GraphBarWidget(
                percent: 100 - rate,
                color: context.extraColors.grey100!,
                textColor: context.extraColors.grey500!,),
              Design.padding4,
            ],),
      ],),
    );
  }

  Widget _kickAndStabButton() {
    return Visibility(
      visible: (widget.userId != Auth.signInfo?.userId),
      child: Container(
        padding: Design.edgePadding,
        height: 92,
        child: Row(
          children: [
            // Kick button
            Expanded(
              child: OutlinedPrimaryButton(
                onPressed: () { },  //< FIXME
                text: context.local.kick,),),
            Design.padding8,

            // Stab button (with Cactus Icon)
            Expanded(
              child: ElevatedButton(
                onPressed: userStabController.stab,
                child: Container(
                  width: double.maxFinite,
                  height: Design.buttonContentHeight,
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(CustomIcons.cactus, size: 20,),
                      Design.padding4,
                      Text(
                        context.local.stab,
                        style: TextStyles.head4,),
                    ],),
                ),),),
          ],),
      ),
    );
  }
}

/// Show status's color, name, and count as Row
class _StatusSummaryWidget extends StatelessWidget {
  static const double _height = 24;

  final StatusTag status;
  final int count;

  const _StatusSummaryWidget({
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
            color: status.color(context),
            shape: BoxShape.circle,),),
        Design.padding12,

        Expanded(
          child: Text(
            status.text(context, false),
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

/// Vertical Percentage Bar (with Tag)
class _GraphBarWidget extends StatelessWidget {
  static const double _widgetWidth = 76;
  static const double _widgetHeight = 200;
  static const double _graphMaxHeightRatio = 1.2; // 1.2 * 100 = 120

  final Color color;
  final Color? textColor;
  final int percent;
  final String headTag;

  const _GraphBarWidget({
    Key? key,
    required this.color,
    required this.percent,
    this.textColor,
    this.headTag = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _widgetWidth,
      height: _widgetHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),

          // Head Tag (such like 'Achieve')
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

          // Percentage Graph
          Container(
            width: 76,
            height: _graphMaxHeightRatio * percent, // MAX_HEIGHT : 1.2 * 100 = 120
            decoration: BoxDecoration(
              color: color,
              borderRadius: Design.borderRadius,),),
          Design.padding8,

          // Percentage Text
          Text(
            "$percent%",
            style: TextStyles.head3.copyWith(
              color: textColor??color,),),
        ],),
    );
  }
}

/// Attendance Rate will be showed as Stacked Bar Chart
class _AttendanceRateChartWidget extends StatelessWidget {
  static const double _height = 30;

  final int attendanceCount;
  final int lateCount;
  final int absentCount;

  const _AttendanceRateChartWidget({
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
          color: (_isEmpty())? context.extraColors.grey100! : null,
          borderRadius: Design.borderRadiusSmall),
      child: Row(
        children: [
          Flexible(
            flex: attendanceCount,
            child: Container(
              color: StatusTag.attendance.color(context),),),

          Visibility(
            visible: (attendanceCount * lateCount != 0), //< FIXME
            child: Design.padding4,),

          Flexible(
            flex: lateCount,
            child: Container(
              color: StatusTag.late.color(context),),),

          Visibility(
            visible: (lateCount * absentCount != 0 || attendanceCount * absentCount != 0),
            child: Design.padding4,),

          Flexible(
            flex: absentCount,
            child: Container(
              color: StatusTag.absent.color(context),),),
        ],),
    );
  }

  bool _isEmpty() {
    return (attendanceCount + absentCount + lateCount <= 0);
  }
}