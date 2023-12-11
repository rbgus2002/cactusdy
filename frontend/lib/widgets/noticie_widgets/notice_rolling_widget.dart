import 'package:flutter/material.dart';
import 'package:group_study_app/models/notice_summary.dart';
import 'package:group_study_app/routes/notices/notice_list_route.dart';
import 'package:group_study_app/themes/color_styles.dart';
import 'package:group_study_app/themes/custom_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/themes/text_styles.dart';
import 'package:group_study_app/utilities/extensions.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/auto_scrolling_banner.dart';

class NoticeRollingWidget extends StatefulWidget {
  final int studyId;

  const NoticeRollingWidget({
    Key? key,
    required this.studyId,
  }) : super(key: key);

  @override
  State<NoticeRollingWidget> createState() => _NoticeRollingWidgetState();
}

class _NoticeRollingWidgetState extends State<NoticeRollingWidget> {
  static const int _showingCount = 3;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Util.pushRoute(context, (context) =>
          NoticeListRoute(studyId: widget.studyId)),
      child: Container(
        alignment: Alignment.centerLeft,
        height: 52,
        padding: const EdgeInsets.symmetric(horizontal: 16),

        decoration: BoxDecoration(
          color: context.extraColors.inputFieldBackgroundColor,
          borderRadius: Design.borderRadiusSmall,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              CustomIcons.notification,
              size: 24,
              color: context.extraColors.grey500,),
            Design.padding8,

            Text(
              context.local.noti,
              style: TextStyles.body1.copyWith(color: ColorStyles.mainColor),),
            Design.padding8,

            Expanded(
              child: FutureBuilder(
                future: NoticeSummary.getNoticeSummaryList(widget.studyId, 0, _showingCount),
                builder: (context, snapshot) =>
                  (snapshot.hasData) ?
                    AutoScrollingBanner(
                      hintText: context.local.tryToWriteNoti,
                      contents: (snapshot.data!).map((n) => n.notice.title).toList(),) :
                    const SizedBox(),
              )),
          ],),
      ),
    );
  }
}