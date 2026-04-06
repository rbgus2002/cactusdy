import 'package:flutter/material.dart';
import 'package:groupstudy/models/notice.dart';
import 'package:groupstudy/routes/notices/notice_create_route.dart';
import 'package:groupstudy/routes/template/pageable_route_template.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/pageable.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/buttons/slow_back_button.dart';
import 'package:groupstudy/widgets/notice_widgets/notice_summary_widget.dart';

class NoticeListRoute extends StatefulWidget {
  final int studyId;

  const NoticeListRoute({
    super.key,
    required this.studyId,
  });

  @override
  State<NoticeListRoute> createState() => _NoticeListRouteState();
}

class _NoticeListRouteState
    extends PageableRouteState<NoticeListRoute, NoticeSummary> {
  @override
  Pageable<NoticeSummary> createPageable() {
    return Pageable<NoticeSummary>(
      fetchSize: 20,
      fetchFunction: (page, size) =>
          NoticeSummary.getNoticeSummaryList2(widget.studyId, page, size),
    );
  }

  @override
  NullableIndexedWidgetBuilder get itemBuilder => (context, index) {
        return NoticeSummaryWidget(
          noticeSummary: pageable.pageInfo!.contents[index],
          studyId: widget.studyId,
          onDelete: () => refresh(),
        );
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.local.notice),
        leading: const SlowBackButton(),
        actions: [_noticeCreationButton()],
      ),
      body: super.build(context),
    );
  }

  Widget _noticeCreationButton() {
    return IconButton(
      icon: const Icon(CustomIcons.writing_square_outline),
      splashRadius: 16,
      onPressed: () => Util.pushRouteWithSlideUp(
              context,
              (context, animation, secondaryAnimation) =>
                  NoticeCreateRoute(studyId: widget.studyId))
          .then((value) => refresh()),
    );
  }
}
