import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/rule.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/routes/home_route.dart';
import 'package:group_study_app/routes/studies/study_edit_route.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/color_util.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/toast.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/dialogs/two_button_dialog.dart';
import 'package:group_study_app/widgets/item_entry.dart';
import 'package:group_study_app/widgets/profile_lists/member_profile_list_widget.dart';
import 'package:group_study_app/widgets/noticie_widgets/notice_rolling_widget.dart';
import 'package:group_study_app/widgets/round_summary_list_widget.dart';
import 'package:group_study_app/widgets/rules/rule_list_widget.dart';

class StudyDetailRoute extends StatefulWidget {
  final Study study;

  const StudyDetailRoute({
    Key? key,
    required this.study,
  }) : super(key: key);

  @override
  State<StudyDetailRoute> createState() => _StudyDetailRouteState();
}

class _StudyDetailRouteState extends State<StudyDetailRoute> {
  static const double _imageSize = 80;
  static const double _iconSize = 32;
  late Study _study;

  @override
  void initState() {
    super.initState();
    _study = widget.study;
  }

  @override
  Widget build(BuildContext context) {
    bool bright = ColorUtil.isBright(_study.color);
    Color appBarForegroundColor = (bright)? Colors.black : Colors.white;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: _study.color,
        foregroundColor: appBarForegroundColor,
        leading: _backButton(appBarForegroundColor),
        actions: [ _studyPopupMenu(appBarForegroundColor) ],
        shape: InputBorder.none,),

      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          clipBehavior: Clip.none,
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Study Image and Appbar
              _profileWidget(_study),

              // Notices and Members
              Container(
                padding: Design.edgePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notice Summary Panel
                    NoticeRollingWidget(studyId: _study.studyId,),
                    Design.padding24,

                    // Member Images
                    Text(
                      context.local.member,
                      style: TextStyles.head5.copyWith(color:
                        context.extraColors.grey800),),
                    Design.padding16,

                    MemberProfileListWidget(
                      studyName: _study.studyName,
                      studyId: _study.studyId,
                      hostId: _study.hostId,),
                    Design.padding12,
                ]),
              ),

              // Study Rules
              Container(
                padding: Design.edgePadding,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(color: context.extraColors.grey100!)),),
                child: FutureBuilder(
                  future: Rule.getRules(widget.study.studyId),
                    builder: (context, snapshot) =>
                      (snapshot.hasData)?
                        RuleListWidget(
                          rules: snapshot.data!,
                          studyId: widget.study.studyId,) :
                        Design.loadingIndicator,),),

              // Study Rounds
              Container(
                padding: Design.edgePadding,
                child: RoundSummaryListWidget(study: _study,),),
            ],),
        ),),
    );
  }

  Widget _profileWidget(Study study) {
    return SizedBox(
      height: 226,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -160,
            child: Container(
              height: 320,
              width: double.maxFinite,
              color: study.color),),

          Positioned(
            left: 20,
            top: 116,
            child: Container(
              width: _imageSize,
              height: _imageSize,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              decoration: BoxDecoration(
                color: ColorUtil.addColor(widget.study.color, context.extraColors.grey000!, 0.4),
                borderRadius: BorderRadius.circular(Design.radiusValue),),
              child: (study.picture.isNotEmpty) ?
                  CachedNetworkImage(
                    imageUrl: study.picture,
                    fit: BoxFit.cover) : null,),),

          Positioned(
            left: 20,
            top: 200,
            child: Text(
                study.studyName,
                style: TextStyles.head3.copyWith(
                    color: context.extraColors.grey800),))
        ],),
    );
  }

  Widget _backButton(Color iconColor) {
    return Padding(
      padding: const EdgeInsets.only(left: 12),
      child: BackButton(color: iconColor),
    );
  }

  Widget _studyPopupMenu(Color iconColor) {
    return PopupMenuButton(
      icon: Icon(
        CustomIcons.more_vert,
        color: iconColor,
        size: _iconSize,),
      splashRadius: _iconSize / 2,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: Design.popupWidth),
      itemBuilder: (context) => [
        // edit profile
        ItemEntry(
          text: context.local.editStudy,
          icon: Icon(CustomIcons.writing_outline, color: context.extraColors.grey900,),
          onTap: () => Util.pushRoute(context, (context) =>
              StudyEditRoute(study: _study,)).then((value) =>
                _refresh(),),),

        // setting
        ItemEntry(
          text: context.local.leaveStudy,
          icon: Icon(CustomIcons.exit_outline, color: context.extraColors.grey900,),
          onTap: _showLeaveStudyDialog,),
      ],);
  }

  Future<void> _refresh() async {
    Study.getStudySummary(_study.studyId).then((study) =>
      setState(() => _study = study));
  }

  void _showLeaveStudyDialog() {
    TwoButtonDialog.showProfileDialog(
        context: context,
        text: context.local.ensureToDo(context.local.leave),

        buttonText1: context.local.no,
        onPressed1: Util.doNothing,

        buttonText2: context.local.willDo(context.local.leave),
        onPressed2: _leaveStudy);
  }

  void _leaveStudy() async {
    try {
      await Study.leaveStudy(widget.study).then((value) {
        Util.pushRouteAndPopUntil(context, (context) => const HomeRoute());
      });
    } on Exception catch(e) {
      if (context.mounted) {
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }
}