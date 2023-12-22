import 'package:flutter/material.dart';
import 'package:groupstudy/models/notice.dart';
import 'package:groupstudy/models/notice_summary.dart';
import 'package:groupstudy/routes/notices/notice_create_route.dart';
import 'package:groupstudy/themes/custom_icons.dart';
import 'package:groupstudy/themes/design.dart';
import 'package:groupstudy/utilities/extensions.dart';
import 'package:groupstudy/utilities/util.dart';
import 'package:groupstudy/widgets/noticie_widgets/notice_summary_widget.dart';

class NoticeListRoute extends StatefulWidget {
  final int studyId;

  const NoticeListRoute({
    Key? key,
    required this.studyId,
  }) : super(key: key);

  @override
  State<NoticeListRoute> createState() => _NoticeListRouteState();
}

class _NoticeListRouteState extends State<NoticeListRoute> {
  late Future<List<NoticeSummary>> futureNoticeSummaryList;

  @override
  void initState() {
    super.initState();
    futureNoticeSummaryList = NoticeSummary.getNoticeSummaryList(widget.studyId, 0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.local.notice,),
        actions: [
          IconButton(
            icon: const Icon(CustomIcons.writing_square_outline),
            splashRadius: 16,
            onPressed: () => Util.pushRouteWithSlideUp(context, (context, animation, secondaryAnimation) =>
                NoticeCreateRoute(studyId: widget.studyId,)
              ).then((value) => _refresh()),)
        ],),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          padding: Design.edgePadding,
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder(
            future: NoticeSummary.getNoticeSummaryList(widget.studyId, 0, 100),
            builder: (context, snapshot) =>
              (!snapshot.hasData) ?
                Design.loadingIndicator :
                ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) =>
                      NoticeSummaryWidget(
                        noticeSummary: snapshot.data![index],
                        studyId: widget.studyId,
                        onDelete: _onDelete,)
                ),
          ),),
      ),
    );
  }

  Future<void> _refresh() async {
    futureNoticeSummaryList = NoticeSummary.getNoticeSummaryList(widget.studyId, 0, 100);
    futureNoticeSummaryList.then((value) => setState((){ }));
  }

  void _onDelete() => _refresh();
}