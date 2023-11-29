import 'package:flutter/material.dart';
import 'package:group_study_app/models/study_Info.dart';
import 'package:group_study_app/models/user.dart';
import 'package:group_study_app/routes/studies/study_create_route.dart';
import 'package:group_study_app/routes/studies/study_detail_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/buttons/add_button.dart';
import 'package:group_study_app/widgets/line_profiles/study_profile_widget.dart';
import 'package:group_study_app/widgets/line_profiles/user_line_profile_widget.dart';
import 'package:group_study_app/widgets/tasks/task_group_widget.dart';

class HomeRoute extends StatefulWidget {
  const HomeRoute({
    Key? key
  }) : super(key: key);

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  static const EdgeInsets _specialPadding = EdgeInsets.all(16);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.extraColors.baseBackgroundColor,
      body: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: _specialPadding,
            child: Column(
              children: [
                Design.padding(76),

                // User Profile
                FutureBuilder(
                    future: User.getUserProfileSummary(),
                    builder: (context, snapshot) =>
                      (snapshot.hasData) ?
                        UserLineProfileWidget(user: snapshot.data!) :
                        Container(height: 48,)),
                Design.padding(44),

                // title line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      context.local.myStudy,
                      style: TextStyles.head5.copyWith(color: context.extraColors.grey800),),
                    AddButton(
                      iconData: CustomIcons.plus_square_outline,
                      text: context.local.addStudy,
                      onTap: () => Util.pushRoute(context, (context) =>
                          const StudyCreateRoute())),
                  ],),
                Design.padding12,

                // study panels
                FutureBuilder(
                  future: StudyInfo.getStudies(),
                  builder: (context, snapshot) =>
                    (snapshot.hasData) ?
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        primary: false,
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) =>
                            _StudyPanel(studyInfo: snapshot.data![index]),) :
                      Design.loadingIndicator,),

                // add study panel
                _AddStudyPanel(),
              ]),
          )
      ),
    );
  }
}

class _Panel extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const _Panel({
    Key? key,
    required this.onTap,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      width: double.infinity,
      child: Ink(
          decoration: BoxDecoration(
            borderRadius: Design.borderRadiusBig,
            color: context.extraColors.grey000,),
          child: InkWell(
            borderRadius: Design.borderRadiusBig,
            onTap: onTap,
            child: Container(
              padding: Design.edgePadding,
              child: child,),)
      ),
    );
  }
}

class _StudyPanel extends StatelessWidget {
  final StudyInfo studyInfo;

  const _StudyPanel({
    Key? key,
    required this.studyInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Panel(
      onTap: () => Util.pushRoute(context, (context) =>
          StudyDetailRoute(study: studyInfo.study,),),
      child: Column(
        children: [
          StudyProfileWidget(studyInfo: studyInfo),
          Design.padding24,

          // task groups
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            primary: false,

            itemCount: studyInfo.taskGroups.length,
            itemBuilder: (context, index) =>
                TaskGroupWidget(
                    taskGroup: studyInfo.taskGroups[index],
                    studyColor: studyInfo.study.color,),
            separatorBuilder: (context, index) => Design.padding20,),
        ],),
    );
  }
}

class _AddStudyPanel extends StatelessWidget {
  static const double _circleRadius = 27;
  static const double _iconSize = 18;
  static const double _height = 256;

  const _AddStudyPanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Panel(
        onTap: () => Util.pushRoute(context, (context) =>
            const StudyCreateRoute()),
        child: SizedBox(
          height: _height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: _circleRadius,
                backgroundColor: ColorStyles.mainColor.withOpacity(0.2),
                child: const Icon(
                  Icons.add,
                  size: _iconSize,
                  color: ColorStyles.mainColor,)),
              Design.padding12,

              Text(
                context.local.createStudy,
                style: TextStyles.head4.copyWith(color: ColorStyles.mainColor)),
            ],
          ),
        )
    );
  }
}