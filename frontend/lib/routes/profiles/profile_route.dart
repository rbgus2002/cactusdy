
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupstudy/models/status_tag.dart';
import 'package:groupstudy/models/study_tag.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/stab_controller.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/outlined_primary_button.dart';
import 'package:groupstudy/widgets/buttons/squircle_widget.dart';
import 'package:groupstudy/widgets/dialogs/two_button_dialog.dart';
import 'package:groupstudy/widgets/tags/study_tag_widget.dart';

class ProfileRoute extends StatefulWidget {
  final int userId;
  final int studyId;
  final VoidCallback? onKick;

  const ProfileRoute({
    super.key,
    required this.userId,
    required this.studyId,
    this.onKick,
  });

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
        leading: const CloseButton(),
        shape: InputBorder.none,),
      body: FutureBuilder(
          future: User.getUserProfileDetail(widget.userId, widget.studyId),
          builder: (context, snapshot) =>
            (snapshot.hasData)?
              ListView(
                children: [
                  _userProfileWidget(snapshot.data!.user),
                  _studyListWidget(snapshot.data!.studyTags),
                  _attendanceRateWidget(snapshot.data!.attendanceRate),
                  _achievementRateWidget(snapshot.data!.doneRate),
                  _kickAndStabButton(snapshot.data!),
                  Design.padding20,
                  _notWithUsNowText(snapshot.data!.isParticipated),
                  Design.padding28,
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

  Widget _kickAndStabButton(UserProfile participantProfile) {
    return Visibility(
      visible: (!Util.isOwner(widget.userId)
            && participantProfile.isParticipated),
      child: Container(
        padding: Design.edgePadding,
        height: 92,
        child: Row(
          children: [
            // Kick button
            Expanded(
              child: OutlinedPrimaryButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  _showKickDialog();
                },
                text: context.local.kick,),),
            Design.padding8,

            // Stab button (with Cactus Icon)
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  userStabController.stab();
                  Toast.showToast(
                    context: context,
                    message: _getStabMessage(
                        participantProfile.user.nickname,
                        userStabController.stabCount),);
                },
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

  void _showKickDialog() {
    TwoButtonDialog.showDialog(
        context: context,
        text: context.local.ensureToDo(context.local.kicking),

        buttonText1: context.local.no,
        onPressed1: Util.doNothing,

        buttonText2: context.local.kick,
        onPressed2: _kickUser);
  }

  void _kickUser() async {
    try {
      await User.kickUser(
          userId: widget.userId,
          studyId: widget.studyId).then((value) =>
            Util.popRoute(context));
      if (widget.onKick != null) {
        widget.onKick!();
      }
    } on Exception catch(e) {
      if (context.mounted) {
        Toast.showToast(
            context: context, 
            message: Util.getExceptionMessage(e));
      }
    }
  }

  String _getStabMessage(String nickname, int stabCount) {
    if (stabCount == 1) {
      return context.local.stabUserAbout(nickname, '');
    }

    else if (stabCount < 5) {
      return context.local.stabUserAbout(nickname, '$stabCount${context.local.num} ');
    }

    return context.local.stabUserAbout(nickname, '$stabCount${context.local.num}${context.local.even} ');
  }

  Widget _notWithUsNowText(bool isParticipated) {
    return Center(
      child: Visibility(
        visible: !isParticipated,
        child: Text(
          context.local.notWithUsNow,
          style: TextStyles.head6.copyWith(
              color: context.extraColors.grey600),
        ),
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
    required this.status,
    required this.count,
  });

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
    required this.color,
    required this.percent,
    this.textColor,
    this.headTag = "",
  });

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
    required this.attendanceCount,
    required this.lateCount,
    required this.absentCount,
  });

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
            visible: _bothNotZero(attendanceCount, lateCount),
            child: Design.padding4,),

          Flexible(
            flex: lateCount,
            child: Container(
              color: StatusTag.late.color(context),),),

          Visibility(
            visible: (_bothNotZero(lateCount, absentCount)
                  || _bothNotZero(attendanceCount, absentCount)),
            child: Design.padding4,),

          Flexible(
            flex: absentCount,
            child: Container(
              color: StatusTag.absent.color(context),),),
        ],),
    );
  }

  bool _bothNotZero(int left, int right) {
    return (left != 0 && right != 0);
  }

  bool _isEmpty() {
    return (attendanceCount + absentCount + lateCount <= 0);
  }
}