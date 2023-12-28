import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:groupstudy/models/study_Info.dart';
import 'package:groupstudy/models/user.dart';
import 'package:groupstudy/routes/start_route.dart';
import 'package:groupstudy/routes/studies/study_create_route.dart';
import 'package:groupstudy/routes/studies/study_detail_route.dart';
import 'package:groupstudy/services/auth.dart';
import 'package:groupstudy/themes/color_styles.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/themes/text_styles.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/toast.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/add_button.dart';
import 'package:groupstudy/widgets/line_profiles/study_profile_widget.dart';
import 'package:groupstudy/widgets/line_profiles/user_line_profile_widget.dart';
import 'package:groupstudy/widgets/tasks/task_group_widget.dart';

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
      appBar: AppBar(
        toolbarHeight: 0,
        backgroundColor: context.extraColors.baseBackgroundColor,
        shape: InputBorder.none,),
      body: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: _specialPadding,
            child: Column(
              children: [
                Design.padding20,

                // User Profile
                FutureBuilder(
                  future: _getUserProfile(),
                  builder: (context, snapshot) =>
                    (snapshot.hasData) ?
                      UserLineProfileWidget(user: snapshot.data!) :
                      Container(height: 48,)),
                Design.padding28,

                // title line
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ' ${context.local.myStudy}',
                      style: TextStyles.head5.copyWith(color: context.extraColors.grey800),),
                    AddButton(
                      iconData: CustomIcons.plus_square_outline,
                      text: context.local.addStudy,
                      onTap: () {
                        HapticFeedback.lightImpact();
                        Util.pushRoute(context, (context) =>
                            const StudyCreateRoute());
                      }),
                  ],),
                Design.padding12,

                // study panels
                FutureBuilder(
                  future: StudyInfo.getStudies(),
                  builder: (context, snapshot) =>
                    (snapshot.hasData)?
                      (snapshot.data!.isEmpty) ?
                        // Empty => Add Panel
                        _AddStudyPanel(onRefresh: _refresh) :
                        // non-Empty => Study Panel List
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          primary: false,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) =>
                              _StudyPanel(
                                  studyInfo: snapshot.data![index],
                                  onRefresh: _refresh),)
                      : Design.loadingIndicator,
                ),
              ]),
          )
      ),
    );
  }

  Future<void> _refresh() async {
    return setState(() { });
  }

  Future _getUserProfile() async {
    try {
      return await User.getUserProfileSummary();
    } on Exception catch (e) {
      String message = Util.getExceptionMessage(e);

      bool unauthorized = (message == 'unauthorized');

      if (unauthorized) {
        Toast.showToast(
            context: context,
            message: context.local.tokenExpired);

        Util.pushRouteAndPopUntil(context, (context) =>
            const StartRoute());
      } else {
        print(e);
      }
    }
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
  final Function onRefresh;

  const _StudyPanel({
    Key? key,
    required this.studyInfo,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Panel(
      onTap: () => Util.pushRoute(context, (context) =>
          StudyDetailRoute(study: studyInfo.study,),).then((value) => onRefresh()),
      child: Column(
        children: [
          StudyProfileWidget(
              studyInfo: studyInfo,
              onRefresh: onRefresh,),
          
          Visibility(
              visible: studyInfo.taskGroups.isNotEmpty,
              child: Design.padding24),

          // task groups
          ListView.separated(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            primary: false,

            itemCount: studyInfo.taskGroups.length,
            itemBuilder: (context, index) =>
                TaskGroupWidget(
                  roundId: studyInfo.round.roundId,
                  userId: Auth.signInfo!.userId,
                  taskGroup: studyInfo.taskGroups[index],
                  study: studyInfo.study,),
            separatorBuilder: (context, index) => Design.padding20,),
        ],),
    );
  }
}

class _AddStudyPanel extends StatelessWidget {
  static const double _circleRadius = 27;
  static const double _iconSize = 18;
  static const double _height = 128;

  final Function onRefresh;

  const _AddStudyPanel({
    Key? key,
    required this.onRefresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _Panel(
        onTap: () => Util.pushRoute(context, (context) =>
            const StudyCreateRoute()).then((value) => onRefresh()),
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
            ],),
        )
    );
  }
}