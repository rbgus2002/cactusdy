import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:group_study_app/models/study.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/widgets/buttons/add_button.dart';
import 'package:group_study_app/widgets/buttons/squircle_widget.dart';
import 'package:group_study_app/widgets/item_entry.dart';
import 'package:group_study_app/widgets/panels/notice_summary_panel.dart';
import 'package:group_study_app/widgets/member_profile_list_widget.dart';
import 'package:group_study_app/widgets/round_info_list_widget.dart';

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
  static const double _popupWidth = 250;
  static const double _imageSize = 80;

  late Future<Study> _futureStudy;

  @override
  void initState() {
    super.initState();
    _futureStudy = Study.getStudySummary(widget.study.studyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: widget.study.color,
        actions: [ _studyPopupMenu() ],
        shape: InputBorder.none,
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Study Image and Appbar
              FutureBuilder(
                future: _futureStudy,
                builder: (context, snapshot) =>
                      (snapshot.hasData)?
                      _profileWidget(snapshot.data!) :
                      _profileWidget(widget.study),),

              // members and
              Container(
                padding: Design.edgePadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Notice Summary Panel
                    NoticeSummaryPanel(studyId: widget.study.studyId,),
                    Design.padding(24),

                    // Member Images
                    Text(
                      context.local.member,
                      style: TextStyles.head5.copyWith(color:
                        context.extraColors.grey800),),
                    Design.padding16,

                    MemberProfileListWidget(studyId: widget.study.studyId),
                    Design.padding32,
                ]),
              ),

              Container(
                padding: Design.edgePadding,
                decoration: BoxDecoration(
                  border: Border.symmetric(
                      horizontal: BorderSide(color: context.extraColors.grey100!)),
                ),
                child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        context.local.rules,
                        style: TextStyles.head5.copyWith(color: context.extraColors.grey800),),
                      AddButton(
                        iconData: CustomIcons.write,
                        text: context.local.writeRule,
                        onTap: () {}),
                    ],),
                ]),
              ),

              Container(
                padding: Design.edgePadding,
                child: RoundInfoListWidget(studyId: widget.study.studyId, studyColor: widget.study.color,),),
            ],
          )
        ),
      )
    );
  }

  Widget _profileWidget(Study study) {
    return SizedBox(
      height: 226,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 160,
            color: study.color),

          Positioned(
            left: 20,
            top: 116,
            child: SquircleWidget(
              scale: _imageSize,
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

  Widget _studyPopupMenu() {
    double iconSize = 32;
    return PopupMenuButton(
      icon: Icon(
        CustomIcons.more_vert,
        color: context.extraColors.grey900,
        size: iconSize,),
      splashRadius: iconSize / 2,
      position: PopupMenuPosition.under,
      constraints: const BoxConstraints(minWidth: _popupWidth),
      itemBuilder: (context) => [
        // edit profile
        ItemEntry(
          text: context.local.editStudy,
          icon: const Icon(CustomIcons.write),),

        // setting
        ItemEntry(
          text: context.local.leaveStudy,
          icon: const Icon(CustomIcons.setting_outline,),),
      ],);
  }
}