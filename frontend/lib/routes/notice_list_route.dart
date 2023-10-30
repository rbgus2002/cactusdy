import 'package:group_study_app/models/notice_summary.dart';

import 'package:flutter/material.dart';
import 'package:group_study_app/routes/create_notice_route.dart';
import 'package:group_study_app/themes/old_app_icons.dart';
import 'package:group_study_app/themes/old_design.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/panels/notice_panel.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: OldAppIcons.add,
            splashRadius: 16,
            onPressed: () {
              Util.pushRoute(context, (context) => CreateNoticeRoute(studyId: widget.studyId));
            },
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => setState(() {}),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: FutureBuilder(
            future: NoticeSummary.getNoticeSummaryList(widget.studyId, 0, 100),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Container(
                  padding: OldDesign.edge15,
                  child: ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) =>
                      NoticePanel(noticeSummary: snapshot.data![index],),
                  )
                );
              }

              return OldDesign.loadingIndicator;
                //return Text("공지가 없어용");
            }
          ,)
          ),
      )
    );
  }
}