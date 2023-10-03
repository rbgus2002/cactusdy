import 'package:group_study_app/models/notice_summary.dart';

import 'package:flutter/material.dart';
import 'package:group_study_app/routes/create_notice_route.dart';
import 'package:group_study_app/themes/app_icons.dart';
import 'package:group_study_app/themes/design.dart';
import 'package:group_study_app/utilities/test.dart';
import 'package:group_study_app/utilities/util.dart';
import 'package:group_study_app/widgets/panels/notice_panel.dart';

class NoticeListRoute extends StatefulWidget {
  final int studyId = Test.testStudy.studyId;
  final int userId = Test.testUser.userId;

  NoticeListRoute({super.key});

  @override
  State<NoticeListRoute> createState() {
    return _NoticeListRoute();
  }
}

class _NoticeListRoute extends State<NoticeListRoute> {
  late Future<List<NoticeSummary>> notices;
  @override
  void initState() {
    super.initState();
    notices = NoticeSummary.getNoticeSummaryList(widget.studyId, 0, 100);
  }

  Future<void> updateNotices() async {
    notices = NoticeSummary.getNoticeSummaryList(widget.studyId, 0, 100);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(shadowColor: Colors.transparent,
        actions: [
          IconButton(
            icon: AppIcons.add,
            splashRadius: 16,
            onPressed: () {
              Util.pushRoute(context, (context) => CreateNoticeRoute());
            },

          )
        ],
      ),
      body: SingleChildScrollView(
        child: FutureBuilder(
          future: notices,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                padding: Design.edge15,
                child: RefreshIndicator(
                    onRefresh: updateNotices,
                    child: Column(
                      children: [
                        for (NoticeSummary notice in snapshot.data!)
                          NoticePanel(noticeSummary: notice),
                      ]
                    )
                ),
              );
            }

            return Design.loadingIndicator;
              //return Text("공지가 없어용");
          }
        ,)
        )
    );
  }
}