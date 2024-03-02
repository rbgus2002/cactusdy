import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupstudy/models/rule.dart';
import 'package:groupstudy/models/study.dart';
import 'package:groupstudy/routes/home_route.dart';
import 'package:groupstudy/routes/studies/study_edit_route.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/color_util.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/focused_menu_button.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/dialogs/two_button_dialog.dart';
import 'package:groupstudy/widgets/haptic_refresh_indicator.dart';
import 'package:groupstudy/widgets/item_entry.dart';
import 'package:groupstudy/widgets/notices_widgets/notice_rolling_widget.dart';
import 'package:groupstudy/widgets/profile_lists/member_profile_list_widget.dart';
import 'package:groupstudy/widgets/rounds/round_summary_list_widget.dart';
import 'package:groupstudy/widgets/rules/rule_list_widget.dart';

class StudyDetailRoute extends StatefulWidget {
  final Study study;

  const StudyDetailRoute({
    super.key,
    required this.study,
  });

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
        leading: SlowBackButton(color: appBarForegroundColor),
        actions: [ _studyPopupMenu(appBarForegroundColor) ],
        shape: InputBorder.none,
        systemOverlayStyle: (bright) ?
          SystemUiOverlayStyle.dark :
          SystemUiOverlayStyle.light,),

      body: HapticRefreshIndicator(
        onRefresh: _refresh,
        edgeOffset: 116, // app bar height
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
                      study: _study,),
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
            top: -320,
            child: Container(
              height: 480,
              width: 30000, //< FIXME
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

  Widget _studyPopupMenu(Color iconColor) {
    return FocusedMenuButton(
        icon: Icon(
          CustomIcons.more_vert,
          color: iconColor,
          size: _iconSize,),
        items:_popupMenuBuilder(context));
  }

  List<PopupMenuEntry> _popupMenuBuilder(BuildContext context) {
    return [
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
    ];
  }

  Future<void> _refresh() async {
    try {
      await
      Study.getStudySummary(_study.studyId).then((study) =>
          setState(() => _study = study));
    } on Exception catch(e) {
      if (mounted) {
        Util.popRoute(context);
        Toast.showToast(
            context: context,
            message: Util.getExceptionMessage(e));
      }
    }
  }

  void _showLeaveStudyDialog() {
    TwoButtonDialog.showDialog(
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